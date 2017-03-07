[![Demo](https://samme.github.io/phaser-plugin-debug-tween/screenshot.png)](https://samme.github.io/phaser-plugin-debug-tween/)

[Demo](https://samme.github.io/phaser-plugin-debug-tween/)

Use
---

```javascript
// @init: ->
game.plugins.add(Phaser.Plugin.DebugTween);

// @render: ->
game.debug.tween(tween, x, y);
game.debug.tweenData(tweenData, x, y);
game.debug.tweenDataInfo(tweenData, x, y);
game.debug.tweenDataValues(tweenData, x, y);
game.debug.tweenInfo(tween, x, y);
```
