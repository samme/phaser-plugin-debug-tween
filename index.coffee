"use strict"

{Phaser} = this

Phaser.Plugin.DebugTween = Object.freeze class DebugTween extends Phaser.Plugin

  _arr = []

  _rect = new Phaser.Rectangle

  tweenColor = (t) ->
    if      t.pendingDelete then colors.RED
    else if t.isPaused      then colors.YELLOW
    else if t.isRunning     then colors.GREEN
    else                         colors.GRAY

  tweenDataColor = (t) ->
    if      t.percent is 1 then colors.BLUE
    else if t.isRunning    then colors.GREEN
    else                        colors.GRAY

  tweenKeys = "chainedTween current frameBased isPaused isRunning properties repeatCounter reverse target timeScale totalDuration".split " "

  tweenDataKeys = "delay dt duration inReverse interpolate isFrom isRunning percent repeatCounter repeatDelay repeatTotal startTime value yoyo yoyoDelay".split " "

  colors =
    RED:    "rgba(255,0,0,0.75)"
    ORANGE: "rgba(255,127,0,0.75)"
    YELLOW: "rgba(255,255,0,0.75)"
    GREEN:  "rgba(0,255,0,0.75)"
    BLUE:   "rgba(0,127,255,0.75)"
    VIOLET: "rgba(255,0,255,0.75)"
    GRAY:   "rgba(127,127,127,0.75)"

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
        val = val.name or val.key or val.constructor or val
      debug.line "#{name}: #{val}"
    debug.stop()
    return

  debugTween: (tween, x, y) ->
    height = (@HEIGHT + @MARGIN) * (tween.timeline.length)
    _rect.setTo x, y, tween.totalDuration / @SCALE, height
    @game.debug.geom _rect, tweenColor(tween), no
    unless tween.pendingDelete
      for t, i in tween.timeline
        @debugTweenData t, x, y
        x += t.duration / @SCALE
        y += (@HEIGHT + @MARGIN)
    return

  debugTweenData: (tweenData, x, y) ->
    {percent} = tweenData
    dur = if percent is 0 then tweenData.duration else tweenData.dt
    _rect.setTo x, y, dur / @SCALE, @HEIGHT
    @game.debug.geom _rect, tweenDataColor(tweenData), yes
    return

  debugTweenDataInfo: (tweenData, x, y) ->
    @debugProps tweenData, tweenDataKeys, x, y
    return

  debugTweenDataValues: (tweenData, x, y) ->
    debug = @game.debug
    {vEnd, vStart} = tweenData
    debug.start x, y
    for prop, val of vStart
      debug.line "#{prop}:"
      debug.line "  start:   #{val.toFixed 2}"
      debug.line "  end:     #{vEnd[prop].toFixed 2}"
      debug.line "  current: #{tweenData.parent.target[prop].toFixed 2}"
    debug.stop()
    return

  debugTweenInfo: (tween, x, y) ->
    @debugProps tween, tweenKeys, x, y
    return
