package pl.asria.tools.display 
{
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public interface IMultiState 
	{
		function set baseState(value:String):void;
		function set subState(value:String):void;
		function gotoCurrentState():void;
		function get baseState():String;
		function get subState():String;
	}
	
}