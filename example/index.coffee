"use strict"

{dat, Phaser} = this

Back = Phaser.Easing.Back
Bounce = Phaser.Easing.Bounce
Quadratic = Phaser.Easing.Quadratic
Rectangle = Phaser.Rectangle

tweenGui = (tween) ->
  gui = new (dat.GUI)
  gui.add tween, "frameBased"
  gui.add(tween, "pendingDelete").listen()
  gui.add tween, "loop"
  gui.add tween, "pause"
  gui.add tween, "repeatAll"
  gui.add(tween, "repeatCounter").listen()
  gui.add tween, "resume"
  gui.add tween, "reverse"
  gui.add tween, "start"
  gui.add tween, "stop"
  gui.add tween, "timeScale", 0.25, 2, 0.25
  gui

window.game = new (Phaser.Game)(
  antialias: no
  width: 960
  height: 1080
  renderer: Phaser.CANVAS
  scaleMode: Phaser.ScaleManager.NO_SCALE
  state:

    init: ->
      @game.plugins.add Phaser.Plugin.DebugTween
      {debug} = @game
      debug.font = "16px monospace"
      debug.lineHeight = 20
      return

    preload: ->
      @load.image "bunny", "example/bunny.png"
      return

    create: ->
      centerX = @world.centerX
      centerY = @world.centerY
      TURN = 2 * Math.PI
      @sprite = @add.sprite(centerX, -centerY, "bunny")
      @sprite.anchor.set 0.5
      @tween = @add.tween(@sprite)
        .to
          y: 1.5 * centerY
        , 1500, Bounce.Out
        .to
          rotation: 1 * TURN
          x: 2 * centerX
        , 1000, Back.InOut
        .to
          rotation: 0
          x: centerX
        , 1000, Back.InOut, no, 500
        .to
          alpha: 0
          y: 2 * centerY
        , 500, Quadratic.In
      @tween.timeScale = 0.5
      @time.events.add 250, (->
        @gui = tweenGui(@tween)
        return
      ), this
      @columns = [
        new Rectangle(0,   320, 320, 320).inflate(-20, 0)
        new Rectangle(320, 320, 320, 320).inflate(-20, 0)
        new Rectangle(640, 320, 320, 320).inflate(-20, 0)
      ]
      @input.onUp.add (-> @tween.start()), this
      window.tween = @tween
      console.log "window.tween", @tween
      return

    render: ->
      debug = @game.debug
      current = @tween.timeline[@tween.current]

      @debugText "Click to start the tween or → use tween controls →", 20, 20, "#7FDBFF"

      debug.tween           @tween,  20,            120
      debug.tweenInfo       @tween,  @columns[0].x, @columns[0].y
      debug.tweenDataInfo   current, @columns[1].x, @columns[1].y
      debug.tweenDataValues current, @columns[2].x, @columns[2].y

      @debugText "game.debug.tween(tween, x, y)",               20,            80
      @debugText "game.debug.tweenInfo(tween, x, y)",           @columns[0].x, @columns[0].y - 100
      @debugText "game.debug.tweenDataInfo(tweenData, x, y)",   @columns[0].x, @columns[0].y - 75
      @debugText "game.debug.tweenDataValues(tweenData, x, y)", @columns[0].x, @columns[0].y - 50

      return

    shutdown: ->
      @gui.destroy()
      return

    debugText: (text, x, y, color = "#999") ->
      {debug} = @game
      debug.text text, x, y, color, debug.font
      return
)
