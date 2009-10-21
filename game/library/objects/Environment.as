package game.library.objects {    	import assets.BackgroundSoundClass;	import assets.CloudClass;	import assets.GullClass;	//import assets.SkyClass;    import assets.SunClass;	import assets.WaveClass;    	import flash.display.Sprite;	import flash.events.Event;    import flash.events.TimerEvent;    import flash.geom.Point;	import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;    import flash.utils.Timer;        /**     * Class for spawning clouds, animating waves etc.     * It is a subclass of Sprite but no graphics are drawn to it, it is a     * container for all of the background sprites. To add it to the scene     * just add the Environment as a child.     */    public class Environment extends flash.display.Sprite implements Pauseable {        		// +1 for full, 0 for silent        public static const BACKGROUND_SOUND_VOLUME:Number = 0.3;				// -1 left, 0 centre, +1 right		public static const BACKGROUND_SOUND_PAN:Number = 0.0;				public static const BACKGROUND_SCALE:Number = 1.0;                public static const NUM_WAVES:Number = 5;        public static const WAVE_SCALE:Number = 1.1;        public static const WAVE_START:Point = new Point(-10, 200);        //public static const WAVE_DISTANCE:Number =        //    (stage.height - WAVE_START_Y) / NUM_WAVES;		public static const WAVE_DISTANCE:Number =		    (600 - WAVE_START.y) / NUM_WAVES;                                public static const MIN_SKY_Y:Number = -50;        public static const MAX_SKY_Y:Number = 100;                public static const SUN_SCALE:Number = 1.0;                public static const NUM_CLOUDS:Number = 5;        public static const CLOUD_SCALE:Number = 0.4;        public static const MIN_CLOUD_SPEED_X:Number = 5;        public static const MAX_CLOUD_SPEED_X:Number = 20;                public static const GULL_SCALE:Number = 0.3;        public static const MIN_GULL_INTERVAL:Number = 5;        public static const MAX_GULL_INTERVAL:Number = 20;        public static const GULL_SPEED_X:Number = 40;                // These sprites are single sprites        //private const background:MovieClip = new Class();                    private const sun:Sprite= new SunClass();                // These sprites are groups of more sprites        private var waves:Sprite = new Sprite();        private var clouds:Sprite = new Sprite();        private var gulls:Sprite = new Sprite();                // Array of speeds in the x direction for each cloud in clouds        private var cloudSpeeds:Array = new Array(NUM_CLOUDS);                // +1 for right, -1 for left        private var cloudDirection:Number;        		// A gull flies past when this timer finishes        private var gullTimer:Timer = null;				// Used to pause the timer		private var paused:Boolean = true;				// Sound		private var sound:Sound = new BackgroundSoundClass();		private var channel:SoundChannel = new SoundChannel();		private var soundPosition:Number = 0;                public function Environment() {                        var i:int;                        // - Setup            // Order is important for layering in the display list                        // - Background            //background.scaleX = BACKGROUND_SCALE;            //background.scaleY = BACKGROUND_SCALE;            //this.addChild(background);                        // - Sun                        // Sun can be halfway off screen            // Random number between            // (-sun.width/2) and (app.width + sun.width/2)            sun.x =                ( Math.random() *                 (600/*stage.width*/ + (sun.width * 0.5)) )                - (sun.width * 0.5);                        // Random number between the sky's min y and max y            sun.y =                MIN_SKY_Y +                (Math.random() * (MAX_SKY_Y - MIN_SKY_Y));                        sun.scaleX = SUN_SCALE;            sun.scaleY = SUN_SCALE;            this.addChild(sun);                        // - Clouds                        // Decide on cloud direction            // Random number between 0 and 1            cloudDirection = Math.random();                        if (cloudDirection > 0.5)            {                // Going right                cloudDirection = 1;            }            else            {                // Going left                cloudDirection = -1;            }                        // Create clouds that move sideways across the screen            var cloud:Sprite;            for (i = 0; i < NUM_CLOUDS; ++i) {                                cloud = new assets.CloudClass();                                // Random number between application min x and max x                cloud.x = Math.random() * 600/*stage.width*/;                                // Random number between the sky's min y and max y                cloud.y =                    MIN_SKY_Y +                    (Math.random() * (MAX_SKY_Y - MIN_SKY_Y));                                cloud.scaleX = CLOUD_SCALE;                cloud.scaleY = CLOUD_SCALE;                                // Add random speed between min x speed and max x speed                cloudSpeeds[i] =                    MIN_CLOUD_SPEED_X +                    (Math.random() * (MAX_CLOUD_SPEED_X - MIN_CLOUD_SPEED_X));                                clouds.addChild(cloud);            }            this.addChild(clouds);                        // - Waves            // Add waves going down the screen            // Wave 0 is at the top of the screen and the bottom of the            // display list            var wave:Sprite;            for (i = 0; i < NUM_WAVES; ++i) {                                wave = new assets.WaveClass();                                wave.x = WAVE_START.x;                wave.y = WAVE_START.y + (i * WAVE_DISTANCE);                                wave.scaleX = WAVE_SCALE;                wave.scaleY = WAVE_SCALE;                                waves.addChild(wave);            }            this.addChild(waves);                        // Randomly generate seagulls                        // Randomly generate a time between min time and max time            var gullTimeS:Number =                MIN_GULL_INTERVAL +                Math.random() * (MAX_GULL_INTERVAL - MIN_GULL_INTERVAL);                            //trace("gullTimeS " + gullTimeS);                            gullTimer = new Timer(gullTimeS * 1000, 1);            gullTimer.addEventListener(TimerEvent.TIMER, onTimerComplete);                        // Paused            //gullTimer.start();                        this.addChild(gulls);            			// Play background sound in loop						// Set volume and panning (left or right)			// Sprite has its own sound transform			this.soundTransform = new SoundTransform(BACKGROUND_SOUND_VOLUME,												     BACKGROUND_SOUND_PAN);						// Paused			soundPosition = 0;			//channel = sound.play(0, 0, this.soundTransform);			//channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);        }                public function update(boatSpeed:Number, frameRate:Number):void {                        var i:int;                        // Move waves down screen at the speed of the boat            for (i = 0; i < waves.numChildren; ++i) {                                var wave:Sprite = waves.getChildAt(i) as Sprite;                wave.y += (boatSpeed / frameRate);                                // Wave reaches bottom of screen                if (wave.y > 600/*stage.height*/) {                                        // Add wave back to top                    wave.y = WAVE_START.y;                                        // Put it to the bottom of the waves                    waves.removeChildAt(i);                    waves.addChildAt(wave, 0);                }            }                        // Move clouds across the top of the screen            const MIN_CLOUD_X:Number = 0 - clouds.getChildAt(0).width + 1;            const MAX_CLOUD_X:Number = stage.width;                        for (i = 0; i < clouds.numChildren; ++i) {                                var cloud:Sprite = clouds.getChildAt(i) as Sprite;                cloud.x += cloudDirection * (cloudSpeeds[i] / frameRate);                                // Cloud reaches left side of screen                if (cloud.x < MIN_CLOUD_X) {                                        // Add cloud back at right side                    cloud.x = MAX_CLOUD_X;                }                                // Cloud reaches right side of screen                else if (cloud.x > MAX_CLOUD_X) {                                        // Add cloud back at left side                    cloud.x = MIN_CLOUD_X;                }            }                        // Move gulls across top of screen            if (gulls.numChildren > 0) {                const MIN_GULL_X:Number = 0 - gulls.getChildAt(0).width + 1;                const MAX_GULL_X:Number = stage.width;                const GULL_DIRECTION:Number = -1;                                for (i = 0; i < gulls.numChildren; ++i) {                    var gull:Sprite = gulls.getChildAt(i) as Sprite;                    gull.x += GULL_DIRECTION * (GULL_SPEED_X / frameRate);                                        // Gull reaches left side of screen                    if (gull.x < MIN_GULL_X) {                                                // Remove gull                        gulls.removeChildAt(i);                    }                                        // Gull reaches right side of screen                    else if (gull.x > MAX_GULL_X) {                                                // Remove gull                        gulls.removeChildAt(i);                    }                }            }        }                private function onTimerComplete(event:TimerEvent):void {                        // Create a gull            var gull:Sprite = new assets.GullClass();                        // Far right of screen            gull.x = stage.width - 1;                        // Random number between the sky's min y and max y            gull.y =                MIN_SKY_Y +                (Math.random() * (MAX_SKY_Y - MIN_SKY_Y));                        gull.scaleX = GULL_SCALE;            gull.scaleY = GULL_SCALE;                            gulls.addChild(gull);                        // Set timer for next gull            // Randomly generate a time between min time and max time            var gullTimeS:Number =                MIN_GULL_INTERVAL +                Math.random() * (MAX_GULL_INTERVAL - MIN_GULL_INTERVAL);                            //trace("gullTimeS " + gullTimeS);                        gullTimer.delay = (gullTimeS * 1000);            gullTimer.reset();                        // Paused            //gullTimer.start();        }				private function onSoundComplete(event:Event):void {						//trace("Background sound loop");						// Play background sound in loop			if (!paused) {				channel = sound.play(0, 0, this.soundTransform);				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);			}		}				public function pause():void {		    			if (!paused) {								paused = true;								// Stop timers				if (gullTimer.running) {					gullTimer.stop();				}								// Stop playing sound and remember position				soundPosition = channel.position;				channel.stop();			}		}		        public function resume():void {                        if (paused) {				                paused = false;								// Start timers                gullTimer.start();								// Start playing sound from position				channel = sound.play(soundPosition, 0, this.soundTransform);				channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);            }        }    }}
