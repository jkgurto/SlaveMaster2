package {
	
	import assets.IntroSoundClass;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import game.library.states.*;
	
	import mx.core.Application;
	
	public class Main extends flash.display.Sprite {
		
		// -- Constants
		// +1 for full, 0 for silent
        public static const START_SOUND_VOLUME:Number = 1.0;
		
		// -1 left, 0 centre, +1 right
		public static const START_SOUND_PAN:Number = 0.0;
		
		// -- Variables
		private var _currentState:String;
		
		private var startSound:Sound = new IntroSoundClass();
		private var startChannel:SoundChannel = new SoundChannel();
		private var startSoundPlaying:Boolean = false;
		
		// Game state
		private var startState:StartState = null;
		private var helpState:HelpState = null;
		private var creditsState:CreditsState = null;
		private var playState:PlayState = null;
		private var pausedState:PausedState = null;
		private var nextLevelState:NextLevelState = null;
		private var gameOverState:GameOverState = null;
		
		public function Main() {
		}
		
		public function setup():void {
		    
		    startState = new StartState(this);
    		helpState = new HelpState(this);
    		creditsState = new CreditsState(this);
    		playState = new PlayState(this);
    		pausedState = new PausedState(this);
    		nextLevelState = new NextLevelState(this);
    		gameOverState = new GameOverState(this);
		    
		    this.addChild(startState);
		    this.addChild(helpState);
		    this.addChild(creditsState);
		    this.addChild(playState);
		    this.addChild(pausedState);
		    this.addChild(gameOverState);
		    
		    // Frame listener
			stage.addEventListener(Event.ENTER_FRAME, this.enterFrame);
			
			// Sets volume and panning (left or right)
			// Sprite has its own sound transform
			this.soundTransform = new SoundTransform(START_SOUND_VOLUME,
												     START_SOUND_PAN);
			
			currentState = "StartState";
			//currentState = "PlayState";
		}
		
		private function enterFrame(event:Event):void {
			
			if (_currentState == "PlayState") {
			    playState.update();
			}
		}
		
		public function get currentState():String {
		    return _currentState;
		}
		
		public function set currentState(value:String):void {
			
			// Exit previous state
			if (_currentState == "StartState") {
				startState.exit();
			}
			else if (_currentState == "HelpState") {
				helpState.exit();
			}
			else if (_currentState == "CreditsState") {
				creditsState.exit();
			}
			else if (_currentState == "PlayState") {
				playState.exit();
			}
			else if (_currentState == "PausedState") {
				pausedState.exit();
			}
			else if (_currentState == "NextLevelState") {
				nextLevelState.exit();
			}
			else if (_currentState == "GameOverState") {
				gameOverState.exit();
			}
			
			// Set new state
			_currentState = value;
		    
		    // Enter new state
			if (_currentState == "StartState") {
				startState.enter();
				
				// Sound
    			if (!startSoundPlaying) {
        			startChannel = startSound.play(0, 0, this.soundTransform);
        			startChannel.addEventListener(Event.SOUND_COMPLETE, onStartSoundComplete);
        			startSoundPlaying = true;
    			}
			}
			else if (_currentState == "HelpState") {
				helpState.enter();
			}
			else if (_currentState == "CreditsState") {
				creditsState.enter();
			}
			else if (_currentState == "PlayState") {
			    
			    // Stop sound
    		    if (startSoundPlaying) {
        			startChannel.stop();
        			startSoundPlaying = false;
    		    }
		    
				playState.enter();
			}
			else if (_currentState == "PausedState") {
			    pausedState.level = playState.difficulty.level;
			    
				pausedState.enter();
			}
			else if (_currentState == "NextLevelState") {
			    
			    playState.reset();
			    
			    nextLevelState.level = playState.difficulty.level;
			    nextLevelState.enter();
			}
			else if (_currentState == "GameOverState") {
			    
			    this.removeChild(playState);
			    playState = new PlayState(this);
			    this.addChild(playState);
			    
			    // Check for win
				gameOverState.win = playState.difficulty.win;
    			gameOverState.enter();
				
				// New difficulty after checking for win
    			//difficulty = new Difficulty(this, positions.length);
			}
			
			// Set stage in focus after removing items or the keyboard events
			// will not register
			stage.focus = stage;
		}
		
		private function onStartSoundComplete(event:Event):void {
			
			//trace("Start sound loop");
			
			// Play sound in loop
			startChannel = startSound.play(0, 0, this.soundTransform);
			startChannel.addEventListener(Event.SOUND_COMPLETE, onStartSoundComplete);
		}
	
	}
}
