# Cookie-Crunch-Adventure

An implementation of [this](http://www.raywenderlich.com/66877/how-to-make-a-game-like-candy-crush-part-1) Swift app tutorial game.


## Code Layout

### Helper classes

The following are some helper classes added for this game:

* **Array2D<T>**: A 2D array, stored under the hood as a normal 1D array.
* **Set<T>**: A collection of unique elements, stored under the hood as a dictionary.
* **Extensions.swift**: A file that provides a way to parse JSON data into a dictionary.

The game flow is designed using the Model-View-Controller (MVC) pattern.

### Model

The game data is represented with the following classes:

* **Cookie**: An item with a "CookieType" enum, sprite, and grid coordinates.
* **Tile**: A spot on the level where a cookie may be located. Level grids can have holes in them where cookies cannot move to.
* **Swap**: Represents two cookies that can be swapped.
* **Chain**: Represents a horizontal or vertical line of similar cookies that can be cleared at once.
* **Level**: The tiles on the game grid, the cookies that sit in them, and a collection of behaviors for modifying said cookies.

### View

The visual representation of the game is primarily handled by the "GameScene" class. It contains a "Level" instance as well as "SKNode" layers to place various sprites onto.

### Controller

The game flow is primarily handled by the "GameViewController" class.

System callbacks are handled by the "AppDelegate" class.
