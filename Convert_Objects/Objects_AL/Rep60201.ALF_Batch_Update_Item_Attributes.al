report 60201 ALF_Batch_Update_Item_Attribut
{
    ApplicationArea = #All;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                  FromItemAttributeValueMapping.Reset;
                  FromItemAttributeValueMapping.SetRange("Table ID",DATABASE::Item);
                  FromItemAttributeValueMapping.SetRange("No.",CopyFromItem);
                  if FromItemAttributeValueMapping.FindSet then begin
                    repeat
                      ExistedItemAttributeValueMapping.Reset;
                      ExistedItemAttributeValueMapping.SetRange("Table ID",DATABASE::Item);
                      ExistedItemAttributeValueMapping.SetRange("No.",Item."No.");
                      ExistedItemAttributeValueMapping.SetRange("Item Attribute ID",FromItemAttributeValueMapping."Item Attribute ID");
                      if ExistedItemAttributeValueMapping.FindFirst then begin
                        ExistedItemAttributeValueMapping."Item Attribute Value ID" := FromItemAttributeValueMapping."Item Attribute Value ID";
                        ExistedItemAttributeValueMapping.Modify;
                      end else begin
                        ToItemAttributeValueMapping.Init;
                        ToItemAttributeValueMapping.TransferFields(FromItemAttributeValueMapping);
                        ToItemAttributeValueMapping."No." := Item."No.";
                        ToItemAttributeValueMapping.Insert;
                      end;
                    until FromItemAttributeValueMapping.Next = 0;
                  end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CopyFromItem;CopyFromItem)
                {
                    ApplicationArea = All;
                    Caption = 'Copy From Item';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if PAGE.RunModal(0,MyItem) = ACTION::LookupOK then begin
                              Text := MyItem."No.";
                              exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        MyItem.Get(CopyFromItem);
                    end;
                }
                field(CopyToItems;CopyToItems)
                {
                    ApplicationArea = All;
                    Caption = 'Copy To Items';
                    Editable = false;
                    ToolTip = 'This report should be run from (filtered) "Item List": Attributes \ ALF Batch Update Item Attributes.';
                }
                field(NumberItems;NumberItems)
                {
                    ApplicationArea = All;
                    Caption = 'Number Items';
                    Editable = false;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CopyToItems := Item.GetFilters;
            NumberItems := Format(Item.Count);
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if CopyFromItem = '' then begin
          Message(TextEmptyCopyFromItem);
          CurrReport.Quit;
        end;

        if CopyToItems = '' then begin
          if not Confirm(TextEmptyCopyToItems,false) then CurrReport.Quit;
        end;

        if not Confirm(TextConfirm,false,NumberItems) then CurrReport.Quit;
    end;

    var
        CopyFromItem: Code[20];
        CopyToItems: Text;
        MyItem: Record Item;
        FromItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ToItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ExistedItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        TextEmptyCopyFromItem: Label 'Copy From Item should not be empty.';
        TextEmptyCopyToItems: Label 'Copy To Items is empty, as result system will update all items. Continue?';
        NumberItems: Text;
        TextConfirm: Label 'System will insert/update item attributes for %1 items. Continue?';
}

