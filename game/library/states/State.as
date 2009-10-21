package game.library.states {
    
    public interface State {
        
        function reset():void;
        function enter():void;
        function exit():void;

    }
}