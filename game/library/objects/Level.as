package game.library.objects {
    
    public class Level {
        
        private var _numSlaves:int;
        private var _distance:int;
        
        public function Level(myNumSlaves:int, myDistance:int) {
            _numSlaves = myNumSlaves;
            _distance = myDistance;
        }
        
        public function get numSlaves():int {
            return _numSlaves;
        }
        
        public function get distance():int {
            return _distance;
        }

    }
}