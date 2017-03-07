// Generated by CoffeeScript 1.10.0
(function() {
  "use strict";
  var Phaser, isArray,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Phaser = this.Phaser;

  isArray = Array.isArray;

  Object.freeze(Phaser.Plugin.DebugTween = (function(superClass) {
    var _rect, colors, tweenColor, tweenDataColor, tweenDataKeys, tweenKeys;

    extend(DebugTween, superClass);

    function DebugTween() {
      return DebugTween.__super__.constructor.apply(this, arguments);
    }

    tweenColor = function(t) {
      if (t.pendingDelete) {
        return colors.RED;
      } else if (t.isPaused) {
        return colors.YELLOW;
      } else if (t.isRunning) {
        return colors.GREEN;
      } else {
        return colors.GRAY;
      }
    };

    tweenDataColor = function(t) {
      if (t.percent === 1) {
        return colors.BLUE;
      } else if (t.isRunning) {
        return colors.GREEN;
      } else {
        return colors.GRAY;
      }
    };

    tweenKeys = "chainedTween current frameBased isPaused isRunning pendingDelete properties repeatCounter reverse target timeScale totalDuration".split(" ");

    tweenDataKeys = "delay dt duration inReverse interpolate isFrom isRunning percent repeatCounter repeatDelay repeatTotal startTime value yoyo yoyoDelay".split(" ");

    colors = {
      RED: "rgba(255,0,0,0.75)",
      ORANGE: "rgba(255,127,0,0.75)",
      YELLOW: "rgba(255,255,0,0.75)",
      GREEN: "rgba(0,255,0,0.75)",
      BLUE: "rgba(0,127,255,0.75)",
      VIOLET: "rgba(255,0,255,0.75)",
      GRAY: "rgba(127,127,127,0.75)"
    };

    DebugTween.prototype.HEIGHT = 15;

    DebugTween.prototype.MARGIN = 0;

    DebugTween.prototype.SCALE = 10;

    DebugTween.prototype.init = function() {
      this.addInterface();
    };

    DebugTween.prototype.addInterface = function() {
      var debug;
      debug = this.game.debug;
      debug.tween = this.debugTween.bind(this);
      debug.tweenData = this.debugTweenData.bind(this);
      debug.tweenDataInfo = this.debugTweenDataInfo.bind(this);
      debug.tweenDataValues = this.debugTweenDataValues.bind(this);
      debug.tweenInfo = this.debugTweenInfo.bind(this);
    };

    DebugTween.prototype.debugProps = function(obj, props, x, y) {
      var debug, j, len, name, val;
      debug = this.game.debug;
      debug.start(x, y);
      if (obj.name) {
        debug.line(obj.name);
      }
      for (j = 0, len = props.length; j < len; j++) {
        name = props[j];
        val = obj[name];
        if (name === "dt" || name === "percent" || name === "value") {
          val = val.toFixed(2);
        } else if (name === "properties") {
          val = Object.keys(val).join(",");
        } else if (name === "target") {
          val = val.name || val.key || val.constructor.name || val;
        }
        debug.line(name + ": " + val);
      }
      debug.stop();
    };

    DebugTween.prototype.debugTween = function(tween, x, y) {
      var height, i, j, len, ref, t;
      height = (this.HEIGHT + this.MARGIN) * tween.timeline.length;
      this.drawRect(x, y, tween.totalDuration / this.SCALE, height, this.game.camera, tweenColor(tween), false);
      if (!tween.pendingDelete) {
        ref = tween.timeline;
        for (i = j = 0, len = ref.length; j < len; i = ++j) {
          t = ref[i];
          this.debugTweenData(t, x, y);
          x += t.duration / this.SCALE;
          y += this.HEIGHT + this.MARGIN;
        }
      }
    };

    DebugTween.prototype.debugTweenData = function(tweenData, x, y) {
      var dur, percent;
      percent = tweenData.percent;
      dur = percent === 0 ? tweenData.duration : tweenData.dt;
      this.drawRect(x, y, dur / this.SCALE, this.HEIGHT, this.game.camera, tweenDataColor(tweenData), true);
    };

    DebugTween.prototype.debugTweenDataInfo = function(tweenData, x, y) {
      this.debugProps(tweenData, tweenDataKeys, x, y);
    };

    DebugTween.prototype.debugTweenDataValues = function(tweenData, x, y) {
      var debug, prop, target, vEnd, vStart, valEnd, valStart;
      debug = this.game.debug;
      vEnd = tweenData.vEnd, vStart = tweenData.vStart;
      target = tweenData.parent.target;
      debug.start(x, y);
      for (prop in vStart) {
        valStart = vStart[prop];
        valEnd = vEnd[prop];
        if (isArray(valEnd)) {
          valEnd = valEnd[valEnd.length - 1];
        }
        debug.line(prop + ":");
        debug.line("  start:   " + (valStart.toFixed(2)));
        if (typeof valEnd === "number") {
          debug.line("  end:     " + (valEnd.toFixed(2)));
        }
        debug.line("  current: " + (target[prop].toFixed(2)));
      }
      if (valStart == null) {
        debug.line("[empty]");
      }
      debug.stop();
    };

    DebugTween.prototype.debugTweenInfo = function(tween, x, y) {
      this.debugProps(tween, tweenKeys, x, y);
    };

    _rect = new Phaser.Rectangle;

    DebugTween.prototype.drawRect = function(x, y, width, height, offset, color, filled) {
      _rect.setTo(x, y, width, height).offsetPoint(offset);
      this.game.debug.rectangle(_rect, color, filled);
    };

    return DebugTween;

  })(Phaser.Plugin));

}).call(this);
