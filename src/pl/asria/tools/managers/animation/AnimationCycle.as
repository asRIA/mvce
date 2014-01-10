/**
* CHANGELOG:
*
* 2011-11-24 17:27: Create file
*/
package pl.asria.tools.managers.animation 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public final class AnimationCycle
	{
		private var _cycle:String;
		private var _intro:String;
		private var _out:String;
		
		public function AnimationCycle(cycle:String, intro:String = null, out:String = null)
		{
			if(cycle == null) throw new Error("main cycle can not be null")
			this._out = out;
			this._intro = intro;
			this._cycle = cycle;
		}
		
		public function get out():String 
		{
			return _out;
		}
		
		public function get intro():String 
		{
			return _intro;
		}
		
		public function get cycle():String 
		{
			return _cycle;
		}
	}

}