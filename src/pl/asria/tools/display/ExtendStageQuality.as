/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-18 08:54</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	
	public class ExtendStageQuality 
	{
	
		public static const AUTO:String = "auto";
		/**
		 * Specifies very high rendering quality: graphics are anti-aliased using a 4 x 4 pixel 
		 * grid and bitmaps are always smoothed.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public static const BEST : String = "best";

		/**
		 * Specifies high rendering quality: graphics are anti-aliased using a 4 x 4 pixel grid, 
		 * and bitmaps are smoothed if the movie is static.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public static const HIGH : String = "high";

		/**
		 * Specifies low rendering quality: graphics are not anti-aliased, and bitmaps are not smoothed.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public static const LOW : String = "low";

		/**
		 * Specifies medium rendering quality: graphics are anti-aliased using a 2 x 2 pixel grid, 
		 * but bitmaps are not smoothed. This setting is suitable for movies that do not contain text.
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 */
		public static const MEDIUM : String = "medium";
		
	}

}