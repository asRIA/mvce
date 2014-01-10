/**
* CHANGELOG:
*
* 2011-12-16 14:12: Create file
*/
package pl.asria.tools.data 
{
	import com.megazebra.games.model.socialactions.SocialActionItem;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class ProgressData 
	{
		private var _vStorage:Vector.<Boolean> = new Vector.<Boolean>();
		public var count:int;
		public var total:int;
		private var _vStorageIteams:Vector.<SocialActionItem> = new Vector.<SocialActionItem>();
		public function ProgressData(total:int = 0, count:int = 0):void
		{
			this.count = count;
			this.total = total;
		}
		
		public function push(requirement:Boolean, data:SocialActionItem = null):void 
		{
			total++;
			if (requirement) count++;
			_vStorage.push(requirement);
			_vStorageIteams.push(data);
		}
		
		public function get uncount():int 
		{
			return total - count;
		}
		
		public function get complete():Boolean 
		{
			return count == total;
		}
		
		public function get vStorage():Vector.<Boolean> 
		{
			return _vStorage;
		}
		
		public function get vStorageIteams():Vector.<SocialActionItem> 
		{
			return _vStorageIteams;
		}
	}

}