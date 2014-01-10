package pl.asria.tools.display.arrayColection 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import pl.asria.tools.display.IMultiState;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.display.SelectableObject;
	import pl.asria.tools.event.display.SelectableArrayCollectionEvent;
	import pl.asria.tools.event.display.SelectableObjectEvent;

	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	//[Event(name="fullSelected", type="pl.asria.utils.event.display.SelectableArrayCollectionEvent")]
	//[Event(name="notFullSelected", type="pl.asria.utils.event.display.SelectableArrayCollectionEvent")]
	public class SelectableArrayCollection extends ArrayCollection
	{
		public var selectedVectorLength:int = 2;
		public var vSelected:Vector.<SelectableObject> = new Vector.<SelectableObject>();
		public function SelectableArrayCollection() 
		{
			
		}
		/**
		 * 
		 * @param	arrayColectionIteam must implemetns IWorkspace, IMultiState or inherited by MultiStateMovieClip and be SelectableObject
		 */
		override public function pushIteam(arrayColectionIteam:IWorkspace):void 
		{
			if(!arrayColectionIteam is IMultiState) throw new Error("arrayColectionIteam must implemetns IWorkspace, IMultiState or inherited by MultiStateMovieClip");
			if(!arrayColectionIteam is SelectableObject) throw new Error("arrayColectionIteam must be SelectableObject");
			super.pushIteam(arrayColectionIteam);
			SelectableObject(arrayColectionIteam).addEventListener(SelectableObjectEvent.SELECT, selectIteamHandler);
			SelectableObject(arrayColectionIteam).addEventListener(SelectableObjectEvent.UNSELECT, unselectIteamHandler);
			
		}
		
		private function unselectIteamHandler(e:SelectableObjectEvent):void 
		{
			if (vSelected.indexOf(e.currentTarget) >= 0)
				vSelected.splice(vSelected.indexOf(e.currentTarget), 1);
			dispatchAccurateEvent();
		}
		
		private function selectIteamHandler(e:SelectableObjectEvent):void 
		{
			if (vSelected.length >= selectedVectorLength) 
			{
				SelectableObject(e.currentTarget).selected = false;
				return;
			}
			if (vSelected.indexOf(e.currentTarget) < 0)
				vSelected.push(e.currentTarget as SelectableObject);
				
			dispatchAccurateEvent();
		}
		
		private function dispatchAccurateEvent():void 
		{
			if (vSelected.length >= selectedVectorLength) 
				dispatchEvent(new SelectableArrayCollectionEvent(SelectableArrayCollectionEvent.FULL_SELECTED));
			else
				dispatchEvent(new SelectableArrayCollectionEvent(SelectableArrayCollectionEvent.NOT_FULL_SELECTED));
		}
	}

}