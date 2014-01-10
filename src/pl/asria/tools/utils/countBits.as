/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-06 15:22</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	
	public function countBits(value:uint):int
	{
		var count:int = 0;
		for (var i:int = 0; i < 32; i++) if (value & (1 << i)) count++;
		return count;
		
	}

}