"use strict"

{Phaser} = this

{isArray} = Array

Object.freeze class Phaser.Plugin.DebugTween extends Phaser.Plugin

  tweenColor = (t) ->
    if      t.pendingDelete then colors.RED
    else if t.isPaused      then colors.YELLOW
    else if t.isRunning     then colors.GREEN
    else                         colors.GRAY

  tweenDataColor = (t) ->
    if      t.percent is 1 then colors.BLUE
    else if t.isRunning    then colors.GREEN
    else                        colors.GRAY

  tweenKeys = "chainedTween current frameBased isPaused isRunning pendingDelete properties repeatCounter reverse target timeScale totalDuration".split " "

  tweenDataKeys = "delay dt duration inReverse interpolate isFrom isRunning percent repeatCounter repeatDelay repeatTotal startTime value yoyo yoyoDelay".split " "

  colors =
    RED:    "#FF4136"
    ORANGE: "#FF851B"
    YELLOW: "#FFDC00"
    GREEN:  "#01FF70"
    BLUE:   "#0074D9"
    VIOLET: "#F012BE"
    GRAY:   "#AAAAAA"

  HEIGHT: 15
  MARGIN: 0
  SCALE: 10

  init: ->
    @addInterface()
    return

  addInterface: ->
    {debug} = @game
    debug.tween           = @debugTween          .bind this
    debug.tweenData       = @debugTweenData      .bind this
    debug.tweenDataInfo   = @debugTweenDataInfo  .bind this
    debug.tweenDataValues = @debugTweenDataValues.bind this
    debug.tweenInfo       = @debugTweenInfo      .bind this
    return

  debugProps: (obj, props, x, y) ->
    debug = @game.debug
    debug.start x, y
    debug.line(obj.name) if obj.name
    for name in props
      val = obj[name]
      if name is "dt" or name is "percent" or name is "value"
        val = val.toFixed 2
      else if name is "properties"
        val = Object.keys(val).join ","
      else if name is "target"
        val = val.name or val.key or val.constructor.name or val
      debug.line "#{name}: #{val}"
    debug.stop()
    return

  debugTween: (tween, x, y) ->
    height = (@HEIGHT + @MARGIN) * (tween.timeline.length)
    @drawRect x, y, tween.totalDuration / @SCALE, height, @game.camera, tweenColor(tween), no
    unless tween.pendingDelete
      for t, i in tween.timeline
        @debugTweenData t, x, y
        x += t.duration / @SCALE
        y += (@HEIGHT + @MARGIN)
    return

  debugTweenData: (tweenData, x, y) ->
    {percent} = tweenData
    dur = if percent is 0 then tweenData.duration else tweenData.dt
    @drawRect x, y, dur / @SCALE, @HEIGHT, @game.camera, tweenDataColor(tweenData), yes
    return

  debugTweenDataInfo: (tweenData, x, y) ->
    @debugProps tweenData, tweenDataKeys, x, y
    return

  debugTweenDataValues: (tweenData, x, y) ->
    debug = @game.debug
    {vEnd, vStart} = tweenData
    {target} = tweenData.parent
    debug.start x, y
    for prop, valStart of vStart
      valEnd = vEnd[prop]
      valEnd = valEnd[valEnd.length - 1] if isArray valEnd
      debug.line "#{prop}:"
      debug.line "  start:   #{valStart.toFixed 2}"
      debug.line "  end:     #{valEnd.toFixed 2}" if typeof valEnd is "number"
      debug.line "  current: #{target[prop].toFixed 2}"
    unless valStart?
      debug.line "[empty]"
    debug.stop()
    return

  debugTweenInfo: (tween, x, y) ->
    @debugProps tween, tweenKeys, x, y
    return

  _rect = new Phaser.Rectangle

  drawRect: (x, y, width, height, offset, color, filled) ->
    _rect
      .setTo x, y, width, height
      .offsetPoint offset
    @game.debug.rectangle _rect, color, filled
    return
