﻿package game.library.objects {		import assets.font2;		import flash.display.Sprite;		import flash.events.TimerEvent;		import flash.geom.Point;		import flash.text.AntiAliasType;	import flash.text.Font;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;    import flash.text.TextFormat;	    import flash.utils.Timer;        import game.library.objects.Boat;    import game.library.objects.Level;		/**	 * Current plan is to get level difficulties from an XML file, however	 * people can cheat and make levels easier	 * Other solution is to hardcode a table in this class that stores all the	 * data required in terms of difficulty per level	 */	public class Difficulty extends Sprite implements Pauseable {	    		public static const DEBUG:Boolean = false;			    public static const DISTANCE_FACTOR:int = 500;	    public static const LEVEL_FACTOR:int = 1000;	    	    // (numSlaves, distance)	    // Make sure numSlaves <= maxSlaves	    // distance = 500 * numSlaves + 1000 * difficulty	    	    public static const LEVEL_1:Level =	        new Level(4, (DISTANCE_FACTOR * 4) + (LEVEL_FACTOR * 1));	        	    public static const LEVEL_2:Level =	        new Level(8, (DISTANCE_FACTOR * 8) + (LEVEL_FACTOR * 2));	        	    public static const LEVEL_3:Level =	        new Level(12, (DISTANCE_FACTOR * 12) + (LEVEL_FACTOR * 3));	        	    public static const LEVEL_4:Level =	        new Level(18, (DISTANCE_FACTOR * 18) + (LEVEL_FACTOR * 4));			    // Debugging	    /*	    public static const LEVEL_1:Level =	        new Level(4, 100);	        	    public static const LEVEL_2:Level =	        new Level(8, 150);	        	    public static const LEVEL_3:Level =	        new Level(12, 200);	        	    public static const LEVEL_4:Level =	        new Level(18, 250);	    */	    		// Same time for each level		public static const MAX_TIME:int = 180;       // Ticks		//public const MAX_TIME:int = 5;       // Ticks		public static const TICK_INTERVAL:int = 1000; // Seconds				public static const LABEL_COLOUR:int = 0xFF0000;		public static const LABEL_SIZE:int = 24;				public static const TEXT_POINT_1:Point = new Point(600, 10);		public static const TEXT_POINT_2:Point = new Point(600, 50);				private var _distanceLeftText:TextField = null;				private var _timeLeftText:TextField = null;        private var _timer:Timer = null;        private var paused:Boolean = true;                private var _level:int;        private var _maxSlaves:int;        private var _numSlaves:int;        private var _distance:int;        private var levels:Array = new Array();        private var _win:Boolean = false;				private var _boat:Boat;				private var _main:Main;				public function Difficulty(main:Main,		                           maxSlaves:int) {						if (DEBUG) {			    trace("New difficulty");			}		    		    // -- Args		    _main = main;		    _maxSlaves = maxSlaves;		    		    // -- Level		    _level = 0;		    		    levels.push(LEVEL_1);		    levels.push(LEVEL_2);		    levels.push(LEVEL_3);		    levels.push(LEVEL_4);		    		    var l:Level = levels[_level];		    _numSlaves = l.numSlaves;		    _distance = l.distance;		    		    // -- Format			var f2:Font = new font2() as Font;					    var format:TextFormat = new TextFormat();			format.font = f2.fontName;			format.color = LABEL_COLOUR;			format.size = LABEL_SIZE;		    		    // -- Distance            _distanceLeftText = new TextField();			            _distanceLeftText.autoSize = TextFieldAutoSize.CENTER;			_distanceLeftText.antiAliasType = AntiAliasType.NORMAL;			_distanceLeftText.embedFonts = true;            _distanceLeftText.defaultTextFormat = format;		                _distanceLeftText.text = "Distance: " + _distance;                        _distanceLeftText.x = TEXT_POINT_1.x;            _distanceLeftText.y = TEXT_POINT_1.y;                        this.addChild(_distanceLeftText);						// -- Timer            _timeLeftText = new TextField();			            _timeLeftText.autoSize = TextFieldAutoSize.CENTER;			_distanceLeftText.antiAliasType = AntiAliasType.NORMAL;			_distanceLeftText.embedFonts = true;            _timeLeftText.defaultTextFormat = format;			            _timeLeftText.text = "Time: " + MAX_TIME;                        _timeLeftText.x = TEXT_POINT_2.x;            _timeLeftText.y = TEXT_POINT_2.y;                        this.addChild(_timeLeftText);                        _timer = new Timer(TICK_INTERVAL, MAX_TIME);            _timer.addEventListener(TimerEvent.TIMER, onTick);            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);                        // Paused            //_timer.start();		}				public function get level():int {			return _level;		}				public function set level(value:int):void {			_level = value;		}				public function get numSlaves():int {			return _numSlaves;		}				public function get distance():int {			return _distance;		}				public function set distance(value:int):void {			_distance = value;			_distanceLeftText.text = "Distance: " + _distance;		}				public function get boat():Boat {			return _boat;		}				public function set boat(value:Boat):void {			_boat = value;		}				public function get win():Boolean {			return _win;		}				public function get distanceLeftText():TextField {		    return _distanceLeftText;		}				public function get timeLeftText():TextField {		    return _timeLeftText;		}				public function nextLevel():void {		    ++_level;		    			if (DEBUG) {		        trace("_level " + _level);			}		    		    // Win		    if (_level >= levels.length) {								if (DEBUG) {				    trace("win " + _win);				}		        		        _win = true;		        		        // Do everything before setting state		        _main.currentState = "GameOverState";		    }		    		    // Next level		    else {								if (DEBUG) {				    trace("next level ");				}						        var l:Level = levels[_level];    		    _numSlaves = l.numSlaves;    		    _distance = l.distance;    		        		    _distanceLeftText.text = "Distance: " + _distance;    		    _timeLeftText.text = "Time: " + MAX_TIME;    		        		    _timer.reset();    		    _timer.start();		        		        // Do everything before setting state		        _main.currentState = "NextLevelState";		    }		}				public function pause():void {		    		    if (_timer.running) {    		    paused = true;    		    _timer.stop();		    }		}		        public function resume():void {                        if (paused) {                paused = false;                _timer.start();            }        }                public function update(frameRate:Number):void {                        _distance -= (_boat.speed / frameRate);            _distanceLeftText.text = "Distance: " + _distance;                        // Distance finished            if (_distance <= 0) {                //_main.setCurrentState("GameOverState");                nextLevel();            }        }				private function onTick(event:TimerEvent):void {		                // -- Timer            // Count down, not up            _timeLeftText.text =                "Time: " + (MAX_TIME - event.target.currentCount);        }                private function onTimerComplete(event:TimerEvent):void        {            // Timer finished            //timeLeftText.text = "Time's Up!";            _main.currentState = "GameOverState";        }			}}