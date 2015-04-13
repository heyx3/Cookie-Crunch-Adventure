import UIKit
import SpriteKit
import AVFoundation


var LevelIndex : Int = 0

class GameViewController: UIViewController {
    
    // The scene draws the tiles and cookie sprites, and handles swipes.
    var scene: GameScene!
    
    // The level contains the tiles, the cookies, and most of the gameplay logic.
    // Needs to be ! because it's not set in init() but in viewDidLoad().
    var level: Level!
    
    var movesLeft = 0
    var score = 0
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var shuffleButton: UIButton!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Load the level.
        level = Level(filename: "Level_\(LevelIndex)")
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        // Hide the game over panel from the screen.
        gameOverPanel.hidden = true
        shuffleButton.hidden = true
        
        // Present the scene.
        skView.presentScene(scene)
        
        // Let's start the game!
        beginGame()
    }
    
    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        
        level.resetComboMultiplier()
        
        scene.animateBeginGame() {
            self.shuffleButton.hidden = false
        }
        
        shuffle()
    }
    
    func shuffle() {
        // Delete the old cookie sprites, but not the tiles.
        scene.removeAllCookieSprites()
        
        // Fill up the level with new cookies, and create sprites for them.
        let newCookies = level.shuffle()
        scene.addSpritesForCookies(newCookies)
    }
    
    // This is the swipe handler. MyScene invokes this function whenever it
    // detects that the player performs a swipe.
    func handleSwipe(swap: Swap) {
        // While cookies are being matched and new cookies fall down to fill up
        // the holes, we don't want the player to tap on anything.
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    // This is the main loop that removes any matching cookies and fills up the
    // holes with new cookies. While this happens, the user cannot interact with
    // the app.
    func handleMatches() {
        // Detect if there are any matches left.
        let chains = level.removeMatches()
        
        // If there are no more matches, then the player gets to move again.
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        
        // First, remove any matches...
        scene.animateMatchedCookies(chains) {
            
            // Add the new scores to the total.
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            
            // ...then shift down any cookies that have a hole below them...
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns) {
                
                // ...and finally, add new cookies at the top.
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns) {
                    
                    // Keep repeating this cycle until there are no more matches.
                    self.handleMatches()
                }
            }
        }
    }
    
    func beginNextTurn() {
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
        decrementMoves()
    }
    
    func updateLabels() {
        movesLabel.text = NSString(format: "%ld", movesLeft) as String
        scoreLabel.text = NSString(format: "%ld", score) as String
    }
    
    func decrementMoves() {
        --movesLeft
        updateLabels()
        
        if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver() {
        gameOverPanel.hidden = false
        scene.userInteractionEnabled = false
        shuffleButton.hidden = true
        
        scene.animateGameOver() {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        
        self.dismissViewControllerAnimated(true) { }
        Skillz.skillzInstance().displayTournamentResultsWithScore(score) { }
        //self.parentViewController?.dismissViewControllerAnimated(true) { }
    }
    
    @IBAction func shuffleButtonPressed(AnyObject) {
        shuffle()
        
        // Pressing the shuffle button costs a move.
        decrementMoves()
    }
}
