package game.library.states {
    
    import fl.controls.Button;
	import fl.controls.Label;
	
	import flash.events.MouseEvent;
    
    import game.library.states.MenuState;
    
    import mx.core.Application;
    
    public class GameOverState extends MenuState {
        
        private var gameOverLabel:Label;
		private var gameOverInfoLabel:Label;
		private var playAgainButton:Button;
		
		private var _win:Boolean = false;
		
        public function GameOverState(m:Main) {
            super(m);
            
            reset();
        }
        
        public function set win(value:Boolean):void {
            _win = value;
        }
        
        override public function reset():void {
            
			// Title
			gameOverLabel = new Label();
			
			//gameOverLabel.autoSize = TextFieldAutoSize.CENTER;
			//gameOverLabel.setStyle("textFormat", labelFormat);
			gameOverLabel.setStyle("fontFamily", labelFormat.font);
			gameOverLabel.setStyle("color", labelFormat.color);
			gameOverLabel.setStyle("size", labelFormat.size);
			
			gameOverLabel.text = "Game Over";
			
			gameOverLabel.x = LABEL_X - (gameOverLabel.width * 0.5);
			gameOverLabel.y = TOP_LABEL_Y - (gameOverLabel.height * 0.5);
			
			// Text
			gameOverInfoLabel = new Label();
			
			//gameOverInfoLabel.setStyle("textFormat", infoLabelFormat);
			gameOverInfoLabel.setStyle("fontFamily", infoLabelFormat.font);
			gameOverInfoLabel.setStyle("color", infoLabelFormat.color);
			gameOverInfoLabel.setStyle("size", infoLabelFormat.size);
			
			// Check for win
			if (_win) {
				gameOverInfoLabel.text = "Win";
			}
			else {
				gameOverInfoLabel.text = "Lose";
			}
			
			gameOverInfoLabel.x = LABEL_X - (gameOverInfoLabel.width * 0.5);
			gameOverInfoLabel.y = gameOverLabel.y + gameOverLabel.height + BUTTON_SPACE_Y;
			
			// Again
			playAgainButton = new Button();
			
			//playAgainButton.setStyle("textFormat", buttonFormat);
			playAgainButton.setStyle("fontFamily", buttonFormat.font);
			playAgainButton.setStyle("color", buttonFormat.color);
			playAgainButton.setStyle("size", buttonFormat.size);
			
			playAgainButton.label = "Play Again";
			
			playAgainButton.x = LABEL_X - (playAgainButton.width * 0.5);
			playAgainButton.y = gameOverInfoLabel.y + gameOverInfoLabel.height + BUTTON_SPACE_Y;
			
        }
        
        override public function enter():void {
            Application.application.canvas.addChild(gameOverLabel);
            Application.application.canvas.addChild(gameOverInfoLabel);
            Application.application.canvas.addChild(playAgainButton);
            
            playAgainButton.addEventListener(MouseEvent.CLICK, playAgainButtonClicked);
        }
        
        override public function exit():void {
            Application.application.canvas.removeChild(gameOverLabel);
			Application.application.canvas.removeChild(gameOverInfoLabel);
			
			playAgainButton.removeEventListener(MouseEvent.CLICK, playAgainButtonClicked);
			Application.application.canvas.removeChild(playAgainButton);
        }
        
        private function playAgainButtonClicked(event:MouseEvent):void {
			_main.currentState = "StartState";
		}

    }
}