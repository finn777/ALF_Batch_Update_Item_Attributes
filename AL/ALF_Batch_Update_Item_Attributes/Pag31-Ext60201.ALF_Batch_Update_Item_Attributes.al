pageextension 60201 ALF_Batch_Update_Item_Attribut extends "Item List"
{
    layout
    {
        // Add changes to page layout here
    }
    
    actions
    {
        // Add changes to page actions here
        addafter(ClearAttributes)
        {

                action("ALF Batch Update Item Attributes")
                
                {
    
                    Promoted = true;
                    Image = UpdateDescription;
                    PromotedCategory = Category10;
                    PromotedOnly = true;
                    ApplicationArea = All;
                    ToolTip = 'ALF Batch Update Item Attributes. The extension does not support RunOnTempRec=True.';
                    trigger OnAction()
                    var
                    MyItem : Record "Item";
                    begin
                        MyItem.COPY(Rec);
                        REPORT.RUNMODAL(REPORT::ALF_Batch_Update_Item_Attribut,TRUE,FALSE,MyItem);
                    end;

                }        
        }        

    }   
 

}
