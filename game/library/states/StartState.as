package game.library.states {
    
    import fl.controls.Button;
	import fl.controls.Label;
	
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
    
    import game.library.states.MenuState;
    
    import mx.core.Application;
    
    public class StartState extends MenuState {
        
		private var startLabel:Label;
		private var startButton:Button;
		private var creditsButton:Button;
		private var helpButton:Button;
		
        public function StartState(m:Main) {
            super(m);
            
            reset();
        }
        
        override public function reset():void {
            
            // Title
			startLabel = new Label();
			
			//startLabel.autoSize = TextFieldAutoSize.CENTER;
			//startLabel.setStyle("textFormat", labelFormat);
			startLabel.setStyle("fontFamily", labelFormat.font);
			startLabel.setStyle("color", labelFormat.color);
			startLabel.setStyle("size", labelFormat.size);
			
			startLabel.text = "Slave Master";
			
			startLabel.x = LABEL_X - (startLabel.width * 0.5);
			startLabel.y = TOP_LABEL_Y - (startLabel.height * 0.5);
			
			startLabel.width = INFO_WIDTH;
			
			// Start
			startButton = new Button();
			
			//startButton.setStyle("textFormat", buttonFormat);
			startButton.setStyle("fontFamily", buttonFormat.font);
			startButton.setStyle("color", buttonFormat.color);
			startButton.setStyle("size", buttonFormat.size);
			
			startButton.label = "Start";
			
			startButton.x = LABEL_X - (startButton.width * 0.5);
			startButton.y = startLabel.y + startLabel.height + BUTTON_SPACE_Y;
			
			// Credits
			creditsButton = new Button();
			
			//creditsButton.setStyle("textFormat", buttonFormat);
			creditsButton.setStyle("fontFamily", buttonFormat.font);
			creditsButton.setStyle("color", buttonFormat.color);
			creditsButton.setStyle("size", buttonFormat.size);
			
			creditsButton.label = "Credits";
			
			creditsButton.x = startButton.x;
			creditsButton.y = startButton.y + startButton.height + BUTTON_SPACE_Y;
			
			// Help
			helpButton = new Button();
			
			//helpButton.setStyle("textFormat", buttonFormat);
			helpButton.setStyle("fontFamily", buttonFormat.font);
			helpButton.setStyle("color", buttonFormat.color);
			helpButton.setStyle("size", buttonFormat.size);
			
			helpButton.label = "Help";
			
			helpButton.x = creditsButton.x;
			helpButton.y = creditsButton.y + creditsButton.height + BUTTON_SPACE_Y;
        }
        
        override public function enter():void {
			
			Application.application.canvas.addChild(startLabel);
			
			// Start
			startButton.addEventListener(MouseEvent.CLICK, startButtonClicked);
			Application.application.canvas.addChild(startButton);
			
			// Credits
			creditsButton.addEventListener(MouseEvent.CLICK, creditsButtonClicked);
			Application.application.canvas.addChild(creditsButton);
			
			// Help
			helpButton.addEventListener(MouseEvent.CLICK, helpButtonClicked);
			Application.application.canvas.addChild(helpButton);
        }
        
        override public function exit():void {
            Application.application.canvas.removeChild(startLabel);
			
			startButton.removeEventListener(MouseEvent.CLICK, startButtonClicked);
			Application.application.canvas.removeChild(startButton);
			
			creditsButton.removeEventListener(MouseEvent.CLICK, creditsButtonClicked);
			Application.application.canvas.removeChild(creditsButton);
			
			helpButton.removeEventListener(MouseEvent.CLICK, helpButtonClicked);
			Application.application.canvas.removeChild(helpButton);
        }
        
        private function startButtonClicked(event:MouseEvent):void {
			_main.currentState = "PlayState";
		}
        
        private function helpButtonClicked(event:MouseEvent):void {
			_main.currentState = "HelpState";
		}
        
        private function creditsButtonClicked(event:MouseEvent):void {
			_main.currentState = "CreditsState";
		}
    }
}
