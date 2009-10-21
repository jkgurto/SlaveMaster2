package game.library.states {
    
    import fl.controls.Button;
	import fl.controls.Label;
	
	import flash.events.MouseEvent;
    
    import game.library.states.MenuState;
    import game.library.states.Text;
    
    import mx.core.Application;
    
    public class CreditsState extends MenuState {
        
        private var creditsLabel:Label;
		private var creditsInfoLabel:Label;
		private var creditsBackButton:Button;
		
        public function CreditsState(m:Main) {
            super(m);
            
            reset();
        }
        
        override public function reset():void {
            // Title
			creditsLabel = new Label();
			
			//creditsLabel.autoSize = TextFieldAutoSize.CENTER;
			//creditsLabel.setStyle("textFormat", labelFormat);
			creditsLabel.setStyle("fontFamily", labelFormat.font);
			creditsLabel.setStyle("color", labelFormat.color);
			creditsLabel.setStyle("size", labelFormat.size);
			
			creditsLabel.text = "Credits";
			
			creditsLabel.x = LABEL_X - (creditsLabel.width * 0.5);
			creditsLabel.y = TOP_LABEL_Y - (creditsLabel.height * 0.5);
			
			// Text
			creditsInfoLabel = new Label();
			
			//creditsInfoLabel.autoSize = TextFieldAutoSize.CENTER;
			//creditsInfoLabel.setStyle("textFormat", infoLabelFormat);
			creditsInfoLabel.setStyle("fontFamily", infoLabelFormat.font);
			creditsInfoLabel.setStyle("color", infoLabelFormat.color);
			creditsInfoLabel.setStyle("size", infoLabelFormat.size);
			
			creditsInfoLabel.text = Text.CREDITS_STRING;
			
			creditsInfoLabel.width = INFO_WIDTH;
			creditsInfoLabel.height = INFO_HEIGHT;
			
			creditsInfoLabel.x = LABEL_X - (creditsInfoLabel.width * 0.5);
			creditsInfoLabel.y = creditsLabel.y + creditsLabel.height + BUTTON_SPACE_Y;
			
			// Back
			creditsBackButton = new Button();
			
			//creditsBackButton.setStyle("textFormat", buttonFormat);
			creditsBackButton.setStyle("fontFamily", buttonFormat.font);
			creditsBackButton.setStyle("color", buttonFormat.color);
			creditsBackButton.setStyle("size", buttonFormat.size);
			
			creditsBackButton.label = "Back";
			
			creditsBackButton.x = LABEL_X - (creditsBackButton.width * 0.5);
			creditsBackButton.y = creditsInfoLabel.y + creditsInfoLabel.height + BUTTON_SPACE_Y;
        }
        
        override public function enter():void {
            Application.application.canvas.addChild(creditsLabel);
            Application.application.canvas.addChild(creditsInfoLabel);
            Application.application.canvas.addChild(creditsBackButton);
            creditsBackButton.addEventListener(MouseEvent.CLICK, creditsBackButtonClicked);
        }
        
        override public function exit():void {
            Application.application.canvas.removeChild(creditsLabel);
			Application.application.canvas.removeChild(creditsInfoLabel);
			
			creditsBackButton.removeEventListener(MouseEvent.CLICK, creditsBackButtonClicked);
			Application.application.canvas.removeChild(creditsBackButton);
        }
        
        private function creditsBackButtonClicked(event:MouseEvent):void {
			_main.currentState = "StartState";
		}

    }
}