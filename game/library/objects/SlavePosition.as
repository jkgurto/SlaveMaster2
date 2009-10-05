package game.library.objects {
    
    import flash.geom.Point;
    
    public class SlavePosition {
        
        private var _position:Point = new Point();
        private var _taken:Boolean = false;
        private var _layer:int = 1;
        
        public function SlavePosition(xx:Number, yy:Number, l:int) {
            _position.x = xx;
            _position.y = yy;
            _layer = l;
        }
        
        public function get x():Number {
            return _position.x;
        }
        
        public function get y():Number {
            return _position.y;
        }
        
        public function get position():Point {
            return _position;
        }
        
        public function get layer():int {
            return _layer;
        }
        
        public function get taken():Boolean {
            return _taken;
        }
        
        public function set taken(value:Boolean):void {
            _taken = value;
        }

    }
}