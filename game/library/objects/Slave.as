package game.library.objects {
	
	import assets.Drum3SoundClass;
	import assets.SlaveClass;
	import assets.WoundsClass;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	
	public class Slave extends assets.SlaveClass {
	    
	    // ------- Properties -------
		public static const SLAVE_SCALE:Number = 0.5;
		
		public static const HANDS_OFFSET:Point = new Point(-185, 0);
		
		public static const WOUNDS_OFFSET:Point = new Point(0,150);
	    public static const DEFAULT_MAX_WHIPS:int = 8;
	    
	    public static const MIN_OUTPUT:Number = 1;
	    public static const MAX_OUTPUT:Number = 20;
	    public static const OUTPUT_DECREASE:Number = 1;
	    
	    // Counts the number of slaves created.
	    private static var slaveCount:uint = 0;
		
		private var _id:uint;
		private var _type:String;    // type descriptor of slave
		
		private var _layer:int = 1;
		
		// number of times whipped
		private var _numWhips:int = DEFAULT_MAX_WHIPS;
		// maximum number of whips
		private var _maxWhips:int = DEFAULT_MAX_WHIPS;
		
		private var _thirst:int;     // thirst as a percentage
		private var _morale:int;     // percentage
		private var _emotion:String; // enum for emotion
		private var _output:Number;  // all factors considered what is the 
		                             // slaves output(contribution)
		private var _speed:int;      //in milliseconds per frame
		private var myHands:Hands;
		
		private var animationSpeed:Number = 1;
		private var _rowing:Boolean = false;
		
		private var deathSound:Sound = new Drum3SoundClass();
	    private var channel:SoundChannel = new SoundChannel();
	    
	    // Wounds
		private var wounds:WoundsClass;
			  
		// constructor
		public function Slave() {
		    ++slaveCount;
		    
		    _id = slaveCount;
		    
		    // name is inherited from sprite
		    // position is also inherited
		    name = "Slave " + _id;
			
			this.scaleX = SLAVE_SCALE;
			this.scaleY = SLAVE_SCALE;
			
			// thirst
			_thirst = 0;
		    
		    // Output
		    _output = MIN_OUTPUT;
		    
		    // Hands
		    myHands = new Hands();
			myHands.x = HANDS_OFFSET.x * Hands.HANDS_SCALE;
			myHands.y = HANDS_OFFSET.y * Hands.HANDS_SCALE;
			this.addChild(myHands);
			this.setChildIndex(myHands, 0);
			
			myHands.stop();
			
			// Wounds/health
			wounds = new WoundsClass();
			wounds.x = WOUNDS_OFFSET.x;
			wounds.y = WOUNDS_OFFSET.y;
			this.addChild(wounds);
		}
		
		public function update(frameRate:Number):void {
		    
		    // Decrease rowing output with time to a minimum
		    if (_output > MIN_OUTPUT) {
		        _output -= (OUTPUT_DECREASE / frameRate);
		    }
		    
		    // Increase thirst
		    if (Math.random() * 100 < 30) {
				_thirst += Math.ceil(_output / (frameRate * 100));
			}
		    
		    // Animate hands based on speed
		    if (_rowing) {
    			var i:int;
    			for (i = 0; i < animationSpeed; ++i) {
    			    
    			    if ( myHands.currentFrame >= (myHands.totalFrames - 1) ) {
    			        myHands.gotoAndStop(0);
    			    }
    			    else {
        				myHands.nextFrame();
        			}
    			}
		    }
		}
		
		public function doWhip():void {
		    
		    if (_numWhips > 0) {
		        
    		    // Set health
    		    --_numWhips;
    		    this.wounds.play();
    		    
    		    // Die
    		    if (_numWhips <= 0) {
    		        die();
    		    }
    		    
    		    // Set rowing output
    		    else {
        		    _output = MAX_OUTPUT;
    		    }
    		    
    			trace(name + " health: " + _numWhips + " / " + _maxWhips);
    			trace(name + " output: " + _output + " / " + MAX_OUTPUT);
		    }
		}
		
		private function die():void {
		    
		    // Play sound
		    channel = deathSound.play();
		    
		    // Animate death
		    // TODO
		}
		
		public function startRow():void {
		    
		    _rowing = true;
		    //trace("startRow");
        }
        
        public function stopRow():void {
		    
		    _rowing = false;
		    //trace("stopRow");
        }
		
		public function isDead():Boolean {
		    
		    if (_numWhips <= 0) {
		        return true;
		    }
		    return false;
		}
		
		public function get id():uint {
		    return _id;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get layer():int {
			return _layer;
		}
		
		public function set layer(value:int):void {
			_layer = value;
		}
		
		public function get numWhips():int {
			return _numWhips;
		}
		
		public function set numWhips(myNumWhips:int):void {
			_numWhips = myNumWhips;
		}
		
		public function get maxWhips():int {
			return _maxWhips;
		}
		
		public function get thirst():int {
			return _thirst;
		}
		
		public function get morale():int {
			return _morale;
		}
		
		public function set morale(myMorale:int):void {
			_morale = myMorale;
		}
		
		public function get emotion():String {
			return _emotion;
		}
		
		public function set emotion(myEmotion:String):void {
			_emotion = myEmotion;
		}
		
		public function get output():Number {
			return _output;
		}
		
		public function set output(myOutput:Number):void {
			_output = myOutput;
		}
		
		public function get speed():int {
			return _speed;
		}
		
		public function set speed(mySpeed:int):void {
			_speed = mySpeed;
			//myHands.speed = mySpeed;
		}
		
		public function recoverThirst(myThirst:int):void {
			_thirst -= myThirst;
			trace(_thirst);
		}
	}
}
