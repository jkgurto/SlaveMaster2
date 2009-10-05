﻿package {
	
	import assets.IntroSoundClass;
	
	import fl.controls.Button;
	import fl.controls.Label;
	
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
	
	import game.library.objects.Text;
	import game.library.objects.Boat;
	import game.library.objects.Difficulty;
	import game.library.objects.Drum;
	import game.library.objects.Environment;
	import game.library.objects.Slave;
	import game.library.objects.SlaveMaster;
	
	import mx.core.Application;
	
	public class Main extends flash.display.Sprite {
		
		// -- Constants
		public static const TOP_LABEL_Y:Number = 150;
		public static const LABEL_X:Number = 400;
		
		public static const BUTTON_SPACE_Y:Number = 22;
		
		public static const INFO_WIDTH:Number = 300;
		public static const INFO_HEIGHT:Number = 200;
		
		public static const LABEL_COLOUR:Number = 0x000000;
		public static const INFO_LABEL_COLOUR:Number = 0x000000;
		public static const BUTTON_COLOUR:Number = 0x000000;
		
		public static const LABEL_SIZE:Number = 20;
		public static const INFO_LABEL_SIZE:Number = 14;
		public static const BUTTON_SIZE:Number = 12;
		
		// +1 for full, 0 for silent
        public static const START_SOUND_VOLUME:Number = 1.0;
		
		// -1 left, 0 centre, +1 right
		public static const START_SOUND_PAN:Number = 0.0;
		
		//private const SPEED_BAR_WIDTH:int = 100;
		private const BOAT_POS:Point = new Point(0, 100);
		private const DRUM_POS:Point = new Point(330, 200);
        
        // Points on the benches
        // Bench 1 - Top left
        public static var POINT_1:Point = new Point(150, 200);
        public static var POINT_2:Point = new Point(220, 200);
        public static var POINT_3:Point = new Point(290, 200);
        
        // Bench 2 - Top right
        public static var POINT_4:Point = new Point(460, 200);
        public static var POINT_5:Point = new Point(530, 200);
        public static var POINT_6:Point = new Point(600, 200);
        
        // Bench 3 - Middle left
        public static var POINT_7:Point = new Point( 80, 290);
        public static var POINT_8:Point = new Point(170, 290);
        public static var POINT_9:Point = new Point(260, 290);
        
        // Bench 4 - Middle right
        public static var POINT_10:Point = new Point(490, 290);
        public static var POINT_11:Point = new Point(580, 290);
        public static var POINT_12:Point = new Point(670, 290);
        
        // Bench 5 - Bottom left
        public static var POINT_13:Point = new Point( 40, 400);
        public static var POINT_14:Point = new Point(140, 400);
        public static var POINT_15:Point = new Point(240, 400);
        
        // Bench 47- Bottom right
        public static var POINT_16:Point = new Point(500, 400);
        public static var POINT_17:Point = new Point(600, 400);
        public static var POINT_18:Point = new Point(700, 400);
		
		// -- Variables
		private var currentState:String;
		
		private var labelFormat:TextFormat;
		private var infoLabelFormat:TextFormat;
		private var buttonFormat:TextFormat;
		
		// Start screen
		private var startLabel:Label;
		private var startButton:Button;
		private var creditsButton:Button;
		private var helpButton:Button;
		
		private var startSound:Sound = new IntroSoundClass();
		private var startChannel:SoundChannel = new SoundChannel();
		private var startSoundPlaying:Boolean = false;
		
		// Credits screen
		private var creditsLabel:Label;
		private var creditsInfoLabel:Label;
		private var creditsBackButton:Button;
		
		// Help screen
		private var helpLabel:Label;
		private var helpInfoLabel:Label;
		private var helpBackButton:Button;
		
		// Paused screen
		private var pausedLabel:Label;
		private var pausedInfoLabel:Label;
		private var continueButton:Button;
		
		// Game over screen
		private var gameOverLabel:Label;
		private var gameOverInfoLabel:Label;
		private var playAgainButton:Button;
		
		// Game objects
		private var boat:Boat = null;
		private var drum:Drum = null;
		private var environment:Environment = null;
		private var slaves:Sprite = new Sprite();
		private var slaveMaster:SlaveMaster = null;
		
		// Game state
		private var difficulty:Difficulty = null;
		private var reset:Boolean = true;
		private var slaveCount:int = 0;
		
		public function Main() {
		}
		
		public function setup():void {
			stage.addEventListener(Event.ENTER_FRAME, this.enterFrame);
			
			labelFormat = new TextFormat();
			labelFormat.color = LABEL_COLOUR;
			labelFormat.size = LABEL_SIZE;
			
			infoLabelFormat = new TextFormat();
			infoLabelFormat.color = INFO_LABEL_COLOUR;
			infoLabelFormat.size = INFO_LABEL_SIZE;
			
			buttonFormat = new TextFormat();
			buttonFormat.color = BUTTON_COLOUR;
			buttonFormat.size = BUTTON_SIZE;
			
			// Sets volume and panning (left or right)
			// Sprite has its own sound transform
			this.soundTransform = new SoundTransform(START_SOUND_VOLUME,
												     START_SOUND_PAN);
												     
			// -- Start listening to keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
			
			setCurrentState("StartState");
			//setCurrentState("PlayState");
		}
		
		private function enterFrame(event:Event):void {
			
			if (currentState == "PlayState") {
			    
			    // -- SlaveMaster
			    slaveMaster.update();
				
				// -- Slaves
				var i:int;
				var slave:Slave;
				
				// DON'T use "for each"
				for (i = 0; i < slaves.numChildren; ++i) {
				    slave = slaves.getChildAt(i) as Slave;
    				slave.update(stage.frameRate);
				}
				
				// -- Drum
				drum.update(stage.frameRate);
				
				if (drum.startRow) {
				    
					drum.startRow = false;
					
					// DON'T use "for each"
					for (i = 0; i < slaves.numChildren; ++i) {
					    slave = slaves.getChildAt(i) as Slave;
        				slave.startRow();
    				}
				}
				else if (drum.stopRow) {
				    
					drum.stopRow = false;
					
					// DON'T use "for each"
					for (i = 0; i < slaves.numChildren; ++i) {
					    slave = slaves.getChildAt(i) as Slave;
        				slave.stopRow();
    				}
				}
				
				// -- Environment
				environment.update(boat.speed, stage.frameRate);
				
				// -- Speed Bar
				//speedBar.setProgress(boat.speed, Slave.MAX_OUTPUT * slaveCount);
				
				// -- Distance to goal
				difficulty.update(stage.frameRate);
			}
		}
		
		private function enterStartState():void {
			
			// Title
			startLabel = new Label();
			
			//startLabel.autoSize = TextFieldAutoSize.CENTER;
			startLabel.setStyle("textFormat", labelFormat);
			
			startLabel.text = "Slave Master";
			
			startLabel.x = LABEL_X - (startLabel.width * 0.5);
			startLabel.y = TOP_LABEL_Y - (startLabel.height * 0.5);
			
			startLabel.width = INFO_WIDTH;
			
			Application.application.canvas.addChild(startLabel);
			
			// Start
			startButton = new Button();
			
			startButton.setStyle("textFormat", buttonFormat);
			
			startButton.label = "Start";
			
			startButton.x = LABEL_X - (startButton.width * 0.5);
			startButton.y = startLabel.y + startLabel.height + BUTTON_SPACE_Y;
			
			startButton.addEventListener(MouseEvent.CLICK, startButtonClicked);
			
			Application.application.canvas.addChild(startButton);
			
			// Credits
			creditsButton = new Button();
			
			creditsButton.setStyle("textFormat", buttonFormat);
			
			creditsButton.label = "Credits";
			
			creditsButton.x = startButton.x;
			creditsButton.y = startButton.y + startButton.height + BUTTON_SPACE_Y;
			
			creditsButton.addEventListener(MouseEvent.CLICK, creditsButtonClicked);
			
			Application.application.canvas.addChild(creditsButton);
			
			// Help
			helpButton = new Button();
			
			helpButton.setStyle("textFormat", buttonFormat);
			
			helpButton.label = "Help";
			
			helpButton.x = creditsButton.x;
			helpButton.y = creditsButton.y + creditsButton.height + BUTTON_SPACE_Y;
			
			helpButton.addEventListener(MouseEvent.CLICK, helpButtonClicked);
			
			Application.application.canvas.addChild(helpButton);
			
			// Sound
			if (!startSoundPlaying) {
    			startChannel = startSound.play(0, 0, this.soundTransform);
    			startChannel.addEventListener(Event.SOUND_COMPLETE, onStartSoundComplete);
    			startSoundPlaying = true;
			}
		}
		
		private function exitStartState():void {
			
			Application.application.canvas.removeChild(startLabel);
			
			startButton.removeEventListener(MouseEvent.CLICK, startButtonClicked);
			Application.application.canvas.removeChild(startButton);
			
			creditsButton.removeEventListener(MouseEvent.CLICK, creditsButtonClicked);
			Application.application.canvas.removeChild(creditsButton);
			
			helpButton.removeEventListener(MouseEvent.CLICK, helpButtonClicked);
			Application.application.canvas.removeChild(helpButton);
			
			// Stop sound
			//startChannel.stop();
		}
		
		private function enterHelpState():void {
			
			// Title
			helpLabel = new Label();
			
			//helpLabel.autoSize = TextFieldAutoSize.CENTER;
			helpLabel.setStyle("textFormat", labelFormat);
			
			helpLabel.text = "Help";
			
			helpLabel.x = LABEL_X - (helpLabel.width * 0.5);
			helpLabel.y = TOP_LABEL_Y - (helpLabel.height * 0.5);
			
			Application.application.canvas.addChild(helpLabel);
			
			// Text
			helpInfoLabel = new Label();
			
			//helpInfoLabel.autoSize = TextFieldAutoSize.CENTER;
			helpInfoLabel.setStyle("textFormat", infoLabelFormat);
			
			helpInfoLabel.text = game.library.objects.Text.HELP_STRING;
			
			helpInfoLabel.width = INFO_WIDTH;
			helpInfoLabel.height = INFO_HEIGHT;
			
			helpInfoLabel.x = LABEL_X - (helpInfoLabel.width * 0.5);
			helpInfoLabel.y = helpLabel.y + helpLabel.height + BUTTON_SPACE_Y;
			
			Application.application.canvas.addChild(helpInfoLabel);
			
			// Back
			helpBackButton = new Button();
			
			helpBackButton.setStyle("textFormat", buttonFormat);
			
			helpBackButton.label = "Back";
			
			helpBackButton.x = LABEL_X - (helpBackButton.width * 0.5);
			helpBackButton.y = helpInfoLabel.y + helpInfoLabel.height + BUTTON_SPACE_Y;
			
			helpBackButton.addEventListener(MouseEvent.CLICK, helpBackButtonClicked);
			
			Application.application.canvas.addChild(helpBackButton);
		}
		
		private function exitHelpState():void {
			
			Application.application.canvas.removeChild(helpLabel);
			Application.application.canvas.removeChild(helpInfoLabel);
			
			helpBackButton.removeEventListener(MouseEvent.CLICK, helpBackButtonClicked);
			Application.application.canvas.removeChild(helpBackButton);
		}
		
		private function enterCreditsState():void {
			
			// Title
			creditsLabel = new Label();
			
			//creditsLabel.autoSize = TextFieldAutoSize.CENTER;
			creditsLabel.setStyle("textFormat", labelFormat);
			
			creditsLabel.text = "Credits";
			
			creditsLabel.x = LABEL_X - (creditsLabel.width * 0.5);
			creditsLabel.y = TOP_LABEL_Y - (creditsLabel.height * 0.5);
			
			Application.application.canvas.addChild(creditsLabel);
			
			// Text
			creditsInfoLabel = new Label();
			
			//creditsInfoLabel.autoSize = TextFieldAutoSize.CENTER;
			creditsInfoLabel.setStyle("textFormat", infoLabelFormat);
			
			creditsInfoLabel.text = game.library.objects.Text.CREDITS_STRING;
			
			creditsInfoLabel.width = INFO_WIDTH;
			creditsInfoLabel.height = INFO_HEIGHT;
			
			creditsInfoLabel.x = LABEL_X - (creditsInfoLabel.width * 0.5);
			creditsInfoLabel.y = creditsLabel.y + creditsLabel.height + BUTTON_SPACE_Y;
			
			Application.application.canvas.addChild(creditsInfoLabel);
			
			// Back
			creditsBackButton = new Button();
			
			creditsBackButton.setStyle("textFormat", buttonFormat);
			
			creditsBackButton.label = "Back";
			
			creditsBackButton.x = LABEL_X - (creditsBackButton.width * 0.5);
			creditsBackButton.y = creditsInfoLabel.y + creditsInfoLabel.height + BUTTON_SPACE_Y;
			
			creditsBackButton.addEventListener(MouseEvent.CLICK, creditsBackButtonClicked);
			
			Application.application.canvas.addChild(creditsBackButton);
		}
		
		private function exitCreditsState():void {
			
			Application.application.canvas.removeChild(creditsLabel);
			Application.application.canvas.removeChild(creditsInfoLabel);
			
			creditsBackButton.removeEventListener(MouseEvent.CLICK, creditsBackButtonClicked);
			Application.application.canvas.removeChild(creditsBackButton);
		}
		
		private function enterPlayState():void {
		    
		    // Stop sound
		    if (startSoundPlaying) {
    			startChannel.stop();
    			startSoundPlaying = false;
		    }
			
			// -- Reset scene
			if (reset) {
				
				reset = false;
				
				// -- Boat
				boat = new Boat();
				boat.x = BOAT_POS.x;
				boat.y = BOAT_POS.y;
				
				// -- Difficulty
				difficulty = new Difficulty(this, boat);
				
				// -- Environment
				environment = new Environment();
				
				// -- Slaves
				// - Remove old slaves
				
				while(slaves.numChildren  > 0) {
    				slaves.removeChildAt(0);
				}
				
				// - Add new slaves
				var slave:Slave;
				
				// - Slave 1
				slave = new Slave();
				
				// Set position
				slave.x = POINT_1.x;
				slave.y = POINT_1.y;
				
				// Add to game
				slaves.addChild(slave);
				boat.addItem(slave);
				++slaveCount;
				
				slave.addEventListener(MouseEvent.CLICK, this.slaveClick);
				
				// - Slave 2
				slave = new Slave();
				
				// Set position
				slave.x = POINT_16.x;
				slave.y = POINT_16.y;
				
				// Add to game
				slaves.addChild(slave);
				boat.addItem(slave);
				++slaveCount;
				
				slave.addEventListener(MouseEvent.CLICK, this.slaveClick);
				
				// - Slave 3
				slave = new Slave();
				
				// Set position
				slave.x = POINT_17.x;
				slave.y = POINT_17.y;
				
				// Add to game
				slaves.addChild(slave);
				boat.addItem(slave);
				++slaveCount;
				
				slave.addEventListener(MouseEvent.CLICK, this.slaveClick);
				
				// - Slave 4
				slave = new Slave();
				
				// Set position
				slave.x = POINT_18.x;
				slave.y = POINT_18.y;
				
				// Add to game
				slaves.addChild(slave);
				boat.addItem(slave);
				++slaveCount;
				
				slave.addEventListener(MouseEvent.CLICK, this.slaveClick); 
				
				// -- Slave Master
				slaveMaster = new SlaveMaster();
				
				// -- Drum
				drum = new Drum();
				drum.x = DRUM_POS.x;
				drum.y = DRUM_POS.y;
				
				boat.drum = drum;
			}
			
			// -- Add scene to stage
			// Layered in order
			stage.addChild(environment);
			stage.addChild(difficulty);
			stage.addChild(boat);
			stage.addChild(drum);
			
			stage.addChild(slaves);
			stage.addChild(slaveMaster);
			
			// -- Start timer
			resumeTimers();
		}
		
		private function exitPlayState():void {
			
			stage.removeChild(environment);
			stage.removeChild(boat);
			stage.removeChild(slaveMaster);
			stage.removeChild(drum);
			
			stage.removeChild(difficulty);
			//stage.removeChild(difficulty.distanceLeftText);
			//stage.removeChild(difficulty.timeLeftText);
			
			//stage.removeChild(drum.beatText);
			
			stage.removeChild(slaves);
			
			// -- Stop timers
			pauseTimers();
		}
		
		private function enterPausedState():void {
			
			// Title
			pausedLabel = new Label();
			
			//pausedLabel.autoSize = TextFieldAutoSize.CENTER;
			pausedLabel.setStyle("textFormat", labelFormat);
			
			pausedLabel.text = "Paused";
			
			pausedLabel.x = LABEL_X - (pausedLabel.width * 0.5);
			pausedLabel.y = TOP_LABEL_Y - (pausedLabel.height * 0.5);
			
			Application.application.canvas.addChild(pausedLabel);
			
			// Text
			pausedInfoLabel = new Label();
			
			//pausedInfoLabel.autoSize = TextFieldAutoSize.CENTER;
			pausedInfoLabel.setStyle("textFormat", infoLabelFormat);
			
			pausedInfoLabel.text = "Level " + difficulty.level;
			
			pausedInfoLabel.x = LABEL_X - (pausedInfoLabel.width * 0.5);
			pausedInfoLabel.y = pausedLabel.y + pausedLabel.height + BUTTON_SPACE_Y;
			
			Application.application.canvas.addChild(pausedInfoLabel);
			
			// Back
			continueButton = new Button();
			
			continueButton.setStyle("textFormat", buttonFormat);
			
			continueButton.label = "Continue";
			
			continueButton.x = LABEL_X - (continueButton.width * 0.5);
			continueButton.y = pausedInfoLabel.y + pausedInfoLabel.height + BUTTON_SPACE_Y;
			
			continueButton.addEventListener(MouseEvent.CLICK, continueButtonClicked);
			
			Application.application.canvas.addChild(continueButton);
		}
		
		private function exitPausedState():void {
			
			Application.application.canvas.removeChild(pausedLabel);
			Application.application.canvas.removeChild(pausedInfoLabel);
			
			continueButton.removeEventListener(MouseEvent.CLICK, continueButtonClicked);
			Application.application.canvas.removeChild(continueButton);
		}
		
		private function enterGameOverState():void {
			reset = true;
			
			// Title
			gameOverLabel = new Label();
			
			//gameOverLabel.autoSize = TextFieldAutoSize.CENTER;
			gameOverLabel.setStyle("textFormat", labelFormat);
			
			gameOverLabel.text = "Game Over";
			
			gameOverLabel.x = LABEL_X - (gameOverLabel.width * 0.5);
			gameOverLabel.y = TOP_LABEL_Y - (gameOverLabel.height * 0.5);
			
			Application.application.canvas.addChild(gameOverLabel);
			
			// Text
			gameOverInfoLabel = new Label();
			
			gameOverInfoLabel.setStyle("textFormat", infoLabelFormat);
			
			if (difficulty.distance <= 0) {
				gameOverInfoLabel.text = "Win";
			}
			else {
				gameOverInfoLabel.text = "Lose";
			}
			
			gameOverInfoLabel.x = LABEL_X - (gameOverInfoLabel.width * 0.5);
			gameOverInfoLabel.y = gameOverLabel.y + gameOverLabel.height + BUTTON_SPACE_Y;
			
			Application.application.canvas.addChild(gameOverInfoLabel);
			
			// Again
			playAgainButton = new Button();
			
			playAgainButton.setStyle("textFormat", buttonFormat);
			
			playAgainButton.label = "Play Again";
			
			playAgainButton.x = LABEL_X - (playAgainButton.width * 0.5);
			playAgainButton.y = gameOverInfoLabel.y + gameOverInfoLabel.height + BUTTON_SPACE_Y;
			
			playAgainButton.addEventListener(MouseEvent.CLICK, playAgainButtonClicked);
			
			Application.application.canvas.addChild(playAgainButton);
		}
		
		private function exitGameOverState():void {
			
			Application.application.canvas.removeChild(gameOverLabel);
			Application.application.canvas.removeChild(gameOverInfoLabel);
			
			playAgainButton.removeEventListener(MouseEvent.CLICK, playAgainButtonClicked);
			Application.application.canvas.removeChild(playAgainButton);
		}
		
		private function slaveClick(event:MouseEvent):void {
		    
		    var slave:Slave;
		    
		    // Use event.currentTarget and not event.target
		    // event.target could refer to assets.Slave and not
		    // game.library.objects.Slave
		    slave = event.currentTarget as Slave;
			
			slaveMaster.doWhip(event);
			slave.doWhip();
			
			if (slave.isDead()) {
				
				// Remove from game
				slaves.removeChild(slave);
				boat.removeItem(slave);
				
				// Check if all the slaves are dead
			    --slaveCount;
				
				if (slaveCount <= 0) {
					setCurrentState("GameOverState");
				}
			}
		}
		
		private function resumeTimers():void {
			difficulty.resume();
			drum.resume();
			environment.resume();
		}
		
		private function pauseTimers():void {
			difficulty.pause();
			drum.pause();
			environment.pause();
		}
		
		private function keyDownHandler(event:KeyboardEvent):void {
			
			if (this.currentState == "PlayState") {
    			if (event.keyCode == Keyboard.ESCAPE) {
    				setCurrentState("GameOverState");
    			}
    			else if (String.fromCharCode(event.charCode) == "p") {
    				setCurrentState("PausedState");
    			}
    			else if (event.keyCode == Keyboard.SPACE) {
    			    trace("space");
    				drum.doBeat();
    			}
			}
		}
		
		private function continueButtonClicked(event:MouseEvent):void {
			setCurrentState("PlayState");
		}
		
		private function helpButtonClicked(event:MouseEvent):void {
			setCurrentState("HelpState");
		}
		
		private function helpBackButtonClicked(event:MouseEvent):void {
			setCurrentState("StartState");
		}
		
		private function creditsButtonClicked(event:MouseEvent):void {
			setCurrentState("CreditsState");
		}
		
		private function creditsBackButtonClicked(event:MouseEvent):void {
			setCurrentState("StartState");
		}
		
		private function playAgainButtonClicked(event:MouseEvent):void {
			setCurrentState("StartState");
		}
		
		private function startButtonClicked(event:MouseEvent):void {
			setCurrentState("PlayState");
		}
		
		public function setCurrentState(myState:String):void {
			
			// Exit previous state
			if (currentState == "StartState") {
				this.exitStartState();
			}
			else if (currentState == "HelpState") {
				this.exitHelpState();
			}
			else if (currentState == "CreditsState") {
				this.exitCreditsState();
			}
			else if (currentState == "PlayState") {
				this.exitPlayState();
			}
			else if (currentState == "PausedState") {
				this.exitPausedState();
			}
			else if (currentState == "GameOverState") {
				this.exitGameOverState();
			}
			
			// Set new state
			currentState = myState;
		    
		    // Enter new state
			if (currentState == "StartState") {
				this.enterStartState();
			}
			else if (currentState == "HelpState") {
				this.enterHelpState();
			}
			else if (currentState == "CreditsState") {
				this.enterCreditsState();
			}
			else if (currentState == "PlayState") {
				this.enterPlayState();
			}
			else if (currentState == "PausedState") {
				this.enterPausedState();
			}
			else if (currentState == "GameOverState") {
				this.enterGameOverState();
			}
		}
		
		private function onStartSoundComplete(event:Event):void {
			
			//trace("Start sound loop");
			
			// Play sound in loop
			startChannel = startSound.play(0, 0, this.soundTransform);
			startChannel.addEventListener(Event.SOUND_COMPLETE, onStartSoundComplete);
		}
	
	}
}
