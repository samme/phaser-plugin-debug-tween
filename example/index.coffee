Back = Phaser.Easing.Back
Bounce = Phaser.Easing.Bounce
Cubic = Phaser.Easing.Cubic
Quadratic = Phaser.Easing.Quadratic
Rectangle = Phaser.Rectangle
YELLOW = 0xffff00
WHITE = 0xffffff

onDown = (sprite) ->
  sprite.tint = YELLOW
  return

onUp = (sprite) ->
  sprite.tint = WHITE
  switch sprite.text
    when 'Start'
      @tween.start()
    when 'Stop'
      @tween.stop()
    when 'Pause'
      @tween.pause()
    when 'Resume'
      @tween.resume()
  return

tweenGui = (tween) ->
  gui = new (dat.GUI)
  gui.add tween, 'frameBased'
  gui.add(tween, 'pendingDelete').listen()
  gui.add tween, 'loop'
  gui.add tween, 'pause'
  gui.add tween, 'repeatAll'
  gui.add(tween, 'repeatCounter').listen()
  gui.add tween, 'resume'
  gui.add tween, 'reverse'
  gui.add tween, 'start'
  gui.add tween, 'stop'
  gui.add tween, 'timeScale', 0.25, 2, 0.25
  gui

new (Phaser.Game)(
  antialias: no
  width: 960
  height: 1080
  renderer: Phaser.CANVAS
  scaleMode: Phaser.ScaleManager.NO_SCALE
  state:

    init: ->
      console.assert Phaser.Plugin.DebugTween, 'Phaser.Plugin.DebugTween'
      @game.plugins.add Phaser.Plugin.DebugTween
      console.assert @game.debug.tween, 'game.debug.tween'
      console.assert @game.debug.tweenData, 'game.debug.tweenData'
      {debug} = @game
      debug.font = '16px monospace'
      debug.lineHeight = 20
      return

    preload: ->
      @load.baseURL = 'http://examples.phaser.io/assets/'
      @load.crossOrigin = 'anonymous'
      @load.image 'bunny', 'sprites/bunny.png'
      return

    create: ->
      centerX = @world.centerX
      centerY = @world.centerY
      TURN = 2 * Math.PI
      @sprite = @add.sprite(centerX, -centerY, 'bunny')
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
      buttons = @add.group()
      buttons.inputEnableChildren = true
      buttons.onChildInputDown.add onDown, this
      buttons.onChildInputUp.add onUp, this
      buttons.setAll 'input.useHandCursor', true
      style =
        fill: 'white'
        font: '32px cursive'
      @add.text 0, 0, 'Start', style, buttons
      @add.text 0, 0, 'Stop', style, buttons
      @add.text 0, 0, 'Pause', style, buttons
      @add.text 0, 0, 'Resume', style, buttons
      buttons.x = 32
      buttons.align -1, 1, 120, 90
      buttons.alignIn @game.camera.view, Phaser.TOP_CENTER
      @columns = [
        new Rectangle(0,   320, 320, 320).inflate(-20, 0)
        new Rectangle(320, 320, 320, 320).inflate(-20, 0)
        new Rectangle(640, 320, 320, 320).inflate(-20, 0)
      ]
      return

    render: ->
      debug = @game.debug
      current = @tween.timeline[@tween.current]

      debug.tween           @tween,  20,            120
      debug.tweenInfo       @tween,  @columns[0].x, @columns[0].y
      debug.tweenDataInfo   current, @columns[1].x, @columns[1].y
      debug.tweenDataValues current, @columns[2].x, @columns[2].y

      @debugText 'game.debug.tween(tween, x, y)',               20,            80
      @debugText 'game.debug.tweenInfo(tween, x, y)',           @columns[0].x, @columns[0].y - 100
      @debugText 'game.debug.tweenDataInfo(tweenData, x, y)',   @columns[0].x, @columns[0].y - 75
      @debugText 'game.debug.tweenDataValues(tweenData, x, y)', @columns[0].x, @columns[0].y - 50

      return

    shutdown: ->
      @gui.destroy()
      return

    debugText: (text, x, y) ->
      {debug} = @game
      debug.text text, x, y, '#999', debug.font
      return
)