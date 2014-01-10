/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-20 11:23</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers 
{
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public interface IJugglable 
	{
		function update(offestTime:int):void;
		function get enableJuggler():Boolean;
	}
	
}