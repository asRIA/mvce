package pl.asria.tools.display.popups 
{
	import pl.asria.tools.display.buttons.BlockButton;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - trzeci.eu
	 */
	public class BlockPopupButtoned extends BlockPopup
	{
		
		public function BlockPopupButtoned() 
		{
			
		}
		
		public function getButton(index:int):BlockButton
		{
			return(getChildByName("button_"+index) as BlockButton)
		}
	}
	
}