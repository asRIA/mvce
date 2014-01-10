/**
* CHANGELOG
* 
* 2011-11-08 11:14: Create file
*/
package pl.asria.tools.managers.focus 
{
	
	/**
	 * Implementation not finished
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IFocusManagerObject 
	{
		/**
		 * Switch between states
		 */
		function set focus(value:int):void;
		function get focus():int;
		
		/**
		 * focus manager is required to focus in grups (one element in one time can be focused for example)
		 * this methot should register instance in FocusManager, when is set again. 
		 * 
		 * unregister in focus manager should be usend in destroy/clean function
		 */
		function set focusManager(value:FocusManager):void;
		
		/**
		 * focus qroups are required in FocusManager to make one element in one time active
		 */
		function set focusGrup(value:String):void;
		function get focusGrup():String;
		function dispatchChangeFocusEvent():void;
	}
	
}