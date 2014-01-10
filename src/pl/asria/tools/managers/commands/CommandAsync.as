/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-09 19:54</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.commands 
{
	
	public class CommandAsync extends Command
	{
		protected var result:CommandAsyncResult;
	
		/**
		 * CommandAsync - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function CommandAsync() 
		{
			
		}
		
		public function executeAsync(description:*):CommandAsyncResult
		{
			result = new CommandAsyncResult();
			result.description = description;
			
			
			return result;
		}
		
		
	}

}