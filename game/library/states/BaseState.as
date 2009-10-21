package game.library.states {
    
    import flash.display.Sprite;
    
    import Main;
    
    public class BaseState extends Sprite implements State {
        
        protected var _main:Main = null;
        
        public function BaseState(m:Main) {
            _main = m;
        }

        public function reset():void {
        }
        
        public function enter():void {
        }
        
        public function exit():void {
        }
        
    }
}