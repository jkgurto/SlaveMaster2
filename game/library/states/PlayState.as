package game.library.states {
    
    import assets.GourdClass;
    
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.ui.Keyboard;
    
    import game.library.objects.Boat;
	import game.library.objects.Difficulty;
	import game.library.objects.Drum;
	import game.library.objects.Environment;
	import game.library.objects.Slave;
	import game.library.objects.SlaveMaster;
	import game.library.objects.SlavePosition;
    
    import game.library.states.BaseState;
    
    import Main;
    
    public class PlayState extends BaseState {
        
        //private const SPEED_BAR_WIDTH:int = 100;
		private const BOAT_POS:Point = new Point(0, 100);
		private const DRUM_POS:Point = new Point(310, 200);
		private const GOURD_POS:Point = new Point(380, 350);
        
        // Points on the benches
        // (x, y, layer)
        // Bench 1 - Top left
        public static var POINT_1:SlavePosition = new SlavePosition(150, 200, 0);
        public static var POINT_2:SlavePosition = new SlavePosition(220, 200, 1);
        public static var POINT_3:SlavePosition = new SlavePosition(290, 200, 2);
        
        // Bench 2 - Top right
        public static var POINT_4:SlavePosition = new SlavePosition(460, 200, 3);
        public static var POINT_5:SlavePosition = new SlavePosition(530, 200, 4);
        public static var POINT_6:SlavePosition = new SlavePosition(600, 200, 5);
        
        // Bench 3 - Middle left
        public static var POINT_7:SlavePosition = new SlavePosition( 80, 290, 6);
        public static var POINT_8:SlavePosition = new SlavePosition(170, 290, 7);
        public static var POINT_9:SlavePosition = new SlavePosition(260, 290, 8);
        
        // Bench 4 - Middle right
        public static var POINT_10:SlavePosition = new SlavePosition(490, 290, 9);
        public static var POINT_11:SlavePosition = new SlavePosition(580, 290, 10);
        public static var POINT_12:SlavePosition = new SlavePosition(670, 290, 11);
        
        // Bench 5 - Bottom left
        public static var POINT_13:SlavePosition = new SlavePosition( 40, 400, 12);
        public static var POINT_14:SlavePosition = new SlavePosition(140, 400, 13);
        public static var POINT_15:SlavePosition = new SlavePosition(240, 400, 14);
        
        // Bench 47- Bottom right
        public static var POINT_16:SlavePosition = new SlavePosition(500, 400, 15);
        public static var POINT_17:SlavePosition = new SlavePosition(600, 400, 16);
        public static var POINT_18:SlavePosition = new SlavePosition(700, 400, 17);
        
        // Game objects
		private var boat:Boat = null;
		private var drum:Drum = null;
		private var environment:Environment = null;
		private var slaves:Sprite = new Sprite();
		private var slaveMaster:SlaveMaster = null;
		
		// Aesthetics
		private var gourd:GourdClass = null;
		private var gourdOn:Boolean = false;
		
		// Game state
		private var _difficulty:Difficulty = null;
		private var slaveCount:int = 0;
		private var gameTimer:int = 0;
		private var positions:Array = new Array();
		private var spaceDown:Boolean = false;
		
        public function PlayState(m:Main) {
            super(m);
            
            // Positions
			positions.push(POINT_1);
			positions.push(POINT_2);
			positions.push(POINT_3);
			positions.push(POINT_4);
			positions.push(POINT_5);
			positions.push(POINT_6);
			positions.push(POINT_7);
			positions.push(POINT_8);
			positions.push(POINT_9);
			positions.push(POINT_10);
			positions.push(POINT_11);
			positions.push(POINT_12);
			positions.push(POINT_13);
			positions.push(POINT_14);
			positions.push(POINT_15);
			positions.push(POINT_16);
			positions.push(POINT_17);
			positions.push(POINT_18);
			
			// -- Difficulty
			_difficulty = new Difficulty(_main, positions.length);
			
			reset();
        }
        
        override public function reset():void {
			
			// -- Boat
			boat = new Boat();
			boat.x = BOAT_POS.x;
			boat.y = BOAT_POS.y;
			
			_difficulty.boat = boat;
			
			// -- Environment
			environment = new Environment();
			
			// -- Slaves
			// - Remove old slaves
			while(slaves.numChildren  > 0) {
				slaves.removeChildAt(0);
			}
			
			var i:int;
			for (i = 0; i < positions.length; ++i) {
			    positions[i].taken = false;
			}
			
			// - Add new slaves
			var slave:Slave;
			
			var j:int;
			for (i = 0; i < _difficulty.numSlaves; ++i) {
			    
			    // Randomly pick a position
				j = int(Math.random() * positions.length);
				trace("index " + j);
				
				// Cycle through positions until one is free
				while (positions[j].taken) {
				    ++j;
				    if (j >= positions.length) {
				        j = 0;
				    }
				}
				
				//trace("final index " + j);
				
				// Take position
				positions[j].taken = true;
				
				slave = new Slave();
				slave.x = positions[j].x;
				slave.y = positions[j].y;
				slave.layer = positions[j].layer;
				
				// Place in correct layer
				//trace("layer " + slave.layer);
				
				var k:int;
				var s:Slave;
				var found:Boolean;
				
				// - No slaves added yet
				if (slaves.numChildren == 0) {
				    
				    //trace("case1");
				    
				    slaves.addChildAt(slave, 0);
				}
				
				// - Other slaves occupying layers
				else {
				    
				    // Go through slaves and check if this slave goes
				    // behind one already added
    				found = false;
    				for (k = 0; (k < slaves.numChildren) && !found; ++k) {
    				    
    				    s = slaves.getChildAt(k) as Slave;
    				    
    				    // Add behind another slave
    				    if (slave.layer <= s.layer) {
    				        
    				        //trace("case2");
    				        
    				        //trace("k " + k);
    				        //trace("slave.layer " + slave.layer);
        				    //trace("s.layer " + s.layer);
    				    
        				    slaves.addChildAt(slave, k);
        				    found = true;
        				}
    				}
    				
    				// Slave goes in front of all other slaves added so far
    				if (!found) {
    				    
    				    //trace("case3");
    				    
    				    // Add to front
    				    slaves.addChildAt(slave, slaves.numChildren);
    				}
				}
				
				boat.addItem(slave);
				++slaveCount;
				
				slave.addEventListener(MouseEvent.CLICK, this.slaveClick);
			}
			
			// -- Drum
			drum = new Drum();
			drum.x = DRUM_POS.x;
			drum.y = DRUM_POS.y;
			
			boat.drum = drum;
			
			// -- Slave Master
			slaveMaster = new SlaveMaster();
			
			// Water Gourd
			gourd = new assets.GourdClass();
			gourd.x = GOURD_POS.x;
			gourd.y = GOURD_POS.y;
			gourd.scaleX = gourd.scaleY = 0.5;
			gourd.addEventListener(MouseEvent.MOUSE_DOWN, this.startWater);
			gourd.addEventListener(MouseEvent.MOUSE_UP, this.stopWater);
			gourd.addEventListener(MouseEvent.MOUSE_OVER, this.hoverWater);
			gourd.addEventListener(MouseEvent.MOUSE_OUT, this.outWater);
			gourd.stop();
			
			// Don't start timers until enter() is called
			pauseTimers();
        }
        
         override public function enter():void {
			
			// -- Add scene to stage
			// Layered in order
			stage.addChild(environment);
			stage.addChild(_difficulty);
			stage.addChild(boat);
			stage.addChild(drum);
			
			stage.addChild(slaves);
			stage.addChild(slaveMaster);
			stage.addChild(gourd);
			
			// -- Start timer
			resumeTimers();
			
			// -- Start listening to keyboard
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUpHandler);
        }
        
        public function update():void {
            
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
			_difficulty.update(stage.frameRate);
			
			gameTimer++;
			
        }
        
        override public function exit():void {
            stage.removeChild(environment);
			stage.removeChild(_difficulty);
			stage.removeChild(boat);
			stage.removeChild(drum);
			stage.removeChild(slaves);
			stage.removeChild(slaveMaster);
			stage.removeChild(gourd);
			
			// -- Stop timers
			pauseTimers();
        }
        
        public function get difficulty():Difficulty {
            return _difficulty;
        }

        private function slaveClick(event:MouseEvent):void {
    		    
		    var slave:Slave;
		    
		    // Use event.currentTarget and not event.target
		    // event.target could refer to assets.Slave and not
		    // game.library.objects.Slave
		    slave = event.currentTarget as Slave;
			
			// Check slave is not already dead
			if (!slave.isDead()) {
    			slaveMaster.doWhip(event);
    			slave.doWhip();
    			
    			if (slave.isDead()) {
    				
    				// Remove from game
    				//slaves.removeChild(slave);
    				boat.removeItem(slave);
    				
    				// Set stage focus if user just clicked on slave
    				stage.focus = stage;
    				
    				// Check if all the slaves are dead
    			    --slaveCount;
    				
    				if (slaveCount <= 0) {
    					_main.currentState = "GameOverState";
    				}
    			}
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void {
		    
		    if (_main.currentState == "PlayState") {
		        
    			if (event.keyCode == Keyboard.SPACE) {
    			    //trace("space up");
    				spaceDown = false;
    			}
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void {
			
			if (_main.currentState == "PlayState") {
			    
    			if (event.keyCode == Keyboard.ESCAPE) {
    				_main.currentState = "GameOverState";
    			}
    			else if (String.fromCharCode(event.charCode) == "p") {
    			    _main.currentState = "PausedState";
    			}
    			else if (event.keyCode == Keyboard.SPACE) {
    			    //trace("space down");
    			    
    			    if (!spaceDown) {
        				drum.doBeat(gameTimer);
        				spaceDown = true;
    			    }
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
        
        private function startWater(e:MouseEvent):void {
			if (gourdOn) {
				gourd.stopDrag();
				gourdOn = false;
			}
			gourd.x = e.stageX - 20;
			gourd.y = e.stageY - 10;
			gourd.startDrag();
			gourd.gotoAndStop("drag");
			gourdOn = true;
		}
		private function stopWater(e:MouseEvent):void {
			gourd.stopDrag();
			gourd.gotoAndStop("start");
			gourdOn = false;
			var i:int;
			var slave:Slave;
			for (i = 0; i < slaves.numChildren; ++i) {
				slave = slaves.getChildAt(i) as Slave;
				if (slave.hitTestPoint(e.stageX, e.stageY)) {
					slave.recoverThirst(15);
				}
			}
			gourd.x = GOURD_POS.x;
			gourd.y = GOURD_POS.y;
		}
		private function hoverWater(e:MouseEvent):void {
			if (!gourdOn) {
				gourd.gotoAndStop("hover");
			}
		}
		private function outWater(e:MouseEvent):void {
			if (!gourdOn) {
				gourd.gotoAndStop("start");
			}
		}

    }
}