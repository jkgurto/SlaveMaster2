﻿package game.library.objects {        import assets.Drum1SoundClass;    import assets.Drum2SoundClass;    import assets.Drum3SoundClass;    import assets.DrummerClass;        import flash.display.MovieClip;	import flash.display.Sprite;    import flash.events.TimerEvent;	import flash.geom.Point;	import flash.media.Sound;	import flash.media.SoundChannel;    import flash.text.TextField;	import flash.text.TextFieldAutoSize;    import flash.text.TextFormat;    import flash.utils.Timer;		/**	 * Drummer animation controls when the player can beat the drum.	 * The player can only beat the drum when the text is written	 * next to the drummer.	 * Beating the drum during this time makes the drummer beat	 * faster.	 */	public class Drum extends assets.DrummerClass implements Pauseable {				// -- Constants		public static const DRUMMER_SCALE:Number = 0.4;				public static const DRUM_POS:Point = new Point(130, 210);		public static const DRUMMER_POS:Point = new Point(0, 0);		public static const TEXT_POS:Point = new Point(0, 0);				// Min and max speeds to animate the drummer		// 1 = base speed		// 2 = double speed		public static const MIN_DRUMMER_SPEED:Number = 3;	    public static const MAX_DRUMMER_SPEED:Number = 10;	    public static const DRUMMER_SPEED_INCREASE:Number = 1.0;	    public static const DRUMMER_SPEED_DECREASE:Number = 0.25;				// Frames to display and hide the beat text at		// Player can hit the drum while the text is displayed		public static const SHOW_BEAT_1:int = 9;		public static const HIDE_BEAT_1:int = 10;				public static const SHOW_BEAT_2:int = 17;		public static const HIDE_BEAT_2:int = 1;	        	    // Time until next row	    public static const MIN_ROW_INTERVAL_S:Number = 0.5;	    public static const MAX_ROW_INTERVAL_S:Number = 1;	    	    public static const ROW_DECREASE_S:Number = 1;	    public static const ROW_INCREASE_S:Number = 0.5;	    	    // Time of row	    public static const ROW_TIME_S:Number = 1;	    	    // -- Variables	    // Sounds	    private var drum1Sound:Sound = new Drum1SoundClass();	    private var drum2Sound:Sound = new Drum2SoundClass();	    private var drum3Sound:Sound = new Drum3SoundClass();	    private var channel:SoundChannel = new SoundChannel();				// Drimmer hits drum with hands, left, right, left, right etc.		private var leftLastBeat:Boolean = false;				// Interval gets smaller as the player gets more correct beats		private var rowIntervalS:Number = MAX_ROW_INTERVAL_S;				// Currently does not change		private var _rowTimeS:Number = ROW_TIME_S;				// Timer for animating the slaves rowing		// Times 2 things alternating		// 1. The time until the next row.		// 2. The time until this row ends.		private var _rowTimer:Timer = new Timer(MAX_ROW_INTERVAL_S * 1000, 1);				// Used to start and stop slave animations		private var _startRow:Boolean = false;		private var _stopRow:Boolean = false;				// Used to tell if the _rowTimer is counting down the time to the		// next row or the time until the row ends.		private var _rowing:Boolean = false;				// Used to pause the timer		private var paused:Boolean = false;				private var _beatText:TextField = null;				// Current speed to animate the drummer with		private var beatSpeed:Number = MIN_DRUMMER_SPEED;				// Counts frames passed		// Used for animating the drummer		private var beatFrame:Number = 0;				/**		 * TODO Timing stuff		 * Needs some tweaking.		 */		public function Drum() {						// -- Timers			_rowTimer.addEventListener(TimerEvent.TIMER, onRowTimerComplete);			_rowTimer.start();						// -- Drummer			this.scaleX = DRUMMER_SCALE;			this.scaleY = DRUMMER_SCALE;						this.x = DRUMMER_POS.x * DRUMMER_SCALE;			this.y = DRUMMER_POS.y * DRUMMER_SCALE;						this.stop();						// -- Format		    var format:TextFormat = new TextFormat();            format.color = 0xFF0000;            format.size = 50;						// -- Beat            _beatText = new TextField();            _beatText.autoSize = TextFieldAutoSize.CENTER;            _beatText.defaultTextFormat = format;            _beatText.text = "Beat";                        _beatText.visible = false;                        // Over top of drum            _beatText.x = TEXT_POS.x;            _beatText.y = TEXT_POS.y;						this.addChild(_beatText);		}				public function update(frameRate:Number):void {		    		    // this.totalFrames == 17		    		    // Animate drummer based on speed		    ++beatFrame;		    		    // Don't forget to cast back to int or it won't be equal		    if (beatFrame == int(frameRate / beatSpeed)) {		        		        beatFrame = 0;		        		        if ( this.currentFrame >= this.totalFrames ) {			        this.gotoAndStop(0);			    }			    else {    				this.nextFrame();    			}		        		        //trace("frame " + this.currentFrame + " / " + this.totalFrames);								// Don't forget to cast back to int or it won't be equal				if ( this.currentFrame == SHOW_BEAT_1) {				    _beatText.visible = true;				    //trace("a");				}				else if ( this.currentFrame == HIDE_BEAT_1) {				    _beatText.visible = false;				    //trace("b");				}				else if (this.currentFrame == SHOW_BEAT_2) {				    _beatText.visible = true;				    //trace("c");				}				else if (this.currentFrame == HIDE_BEAT_2) {				    _beatText.visible = false;				    //trace("d");				}		    }		    		    //increaseRowInterval(frameRate);						// Decrease drummer speed			decreaseBeatSpeed(frameRate);		}				public function doBeat(b:int):void {		    		    // Only hit drum when it indicates to			if (_beatText.visible) {			    _beatText.visible = false;    			    			// Left last beat    			if (leftLastBeat) {    			    leftLastBeat = false;    			        			    // Make time until next row shorter    			    decreaseRowInterval();    			        			    // Speed up drummer    			    increaseBeatSpeed();        		            		    // Play sound        		    channel = drum1Sound.play();    			}    			    			// Right last beat    			else if (!leftLastBeat) {    			    leftLastBeat = true;    			        			    // Make time until next row shorter    			    decreaseRowInterval();    			        			    // Speed up drummer    			    increaseBeatSpeed();        		            		    // Play sound        		    channel = drum2Sound.play();    			}    			    			//channel = drum3Sound.play();			}		}				private function decreaseRowInterval():void {		    rowIntervalS -= ROW_DECREASE_S;		    		    // Clamp to minimum value		    if (rowIntervalS < MIN_ROW_INTERVAL_S) {		        rowIntervalS = MIN_ROW_INTERVAL_S;		    }		    		    // Timer interval is updated next row		    		    //trace("dec rowInterval " + rowIntervalS);		}				private function increaseRowInterval(frameRate:Number):void {		    rowIntervalS += (ROW_INCREASE_S / frameRate);		    		    // Clamp to minimum value		    if (rowIntervalS > MAX_ROW_INTERVAL_S) {		        rowIntervalS = MAX_ROW_INTERVAL_S;		    }		    		    // Timer interval is updated next row		    		    //trace("inc rowInterval " + rowIntervalS);		}				private function increaseBeatSpeed():void {		    beatSpeed += DRUMMER_SPEED_INCREASE;		    		    // Clamp to minimum value		    if (beatSpeed > MAX_DRUMMER_SPEED) {		        beatSpeed = MAX_DRUMMER_SPEED;		    }		}				private function decreaseBeatSpeed(frameRate:Number):void {		    beatSpeed -= (DRUMMER_SPEED_DECREASE / frameRate);						if (beatSpeed < MIN_DRUMMER_SPEED) {			    beatSpeed = MIN_DRUMMER_SPEED;			}		}				public function get beatText():TextField {		    return _beatText;		}				/**		 * Check if slaves have just started to row.		 */		public function get startRow():Boolean {		    return _startRow;		}				/**		 * Set if slaves have just started to row.		 * startRow should be set to false after the slaves have been updated.		 */		public function set startRow(value:Boolean):void {		    _startRow = value;		}				/**		 * Check if slaves have just stopped a row.		 */		public function get stopRow():Boolean {		    return _stopRow;		}				/**		 * Set if slaves have just stopped a row.		 * stopRow should be set to false after the slaves have been updated.		 */		public function set stopRow(value:Boolean):void {		    _stopRow = value;		}				public function get rowing():Boolean {		    return _rowing;		}				public function get rowTimer():Timer {		    return _rowTimer;		}				public function get rowTimeS():Number {		    return _rowTimeS;		}				public function pause():void {		    		    if (_rowTimer.running) {    		    paused = true;    		    _rowTimer.stop();		    }		}		        public function resume():void {                        if (paused) {                paused = false;                _rowTimer.start();            }        }                private function onRowTimerComplete(event:TimerEvent):void        {            // Slaves are waiting to row            if (!_rowing) {                _rowing = true;                _startRow = true;                                _rowTimer.delay = (_rowTimeS * 1000);                _rowTimer.reset();                _rowTimer.start();                                //trace("rowTime " + rowTimeS);            }                        // Slaves are rowing            else {                _rowing = false;                _stopRow = true;                                _rowTimer.delay = (rowIntervalS * 1000);                _rowTimer.reset();                _rowTimer.start();                                //trace("rowInterval " + rowIntervalS);            }        }	}}