Table 6188710 "ForNAV Inv. to G/L Arguments"
{
    fields
    {
        field(1;"To Date";Date)
        {
            Caption = 'To Date';
            DataClassification = SystemMetadata;
        }
        field(2;"Location Code";Boolean)
        {
            Caption = 'Location Code';
            DataClassification = SystemMetadata;
        }
        field(3;"Variant Code";Boolean)
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
        }
        field(4;"Amounts in Add. Currency";Boolean)
        {
            Caption = 'Amounts in Add. Currency';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1;"To Date")
        {
        }
    }
    fieldgroups
    {
    }
    procedure CreateBuffer(var Item: Record Item;
    var InvToGLBuffer: Record "ForNAV Inventory to G/L Buffer")var InvToGLRecon: Query "ForNAV Inventory to G/L Recon.";
    begin
        InvToGLBuffer.Reset;
        InvToGLBuffer.DeleteAll;
        InvToGLRecon.SetRange(No, Item."No.");
        InvToGLRecon.SetRange(Date_Filter, 0D, "To Date");
        InvToGLRecon.SetFilter(Valued_Quantity, '<0');
        InvToGLRecon.Open;
        while InvToGLRecon.Read do begin
            CreateRowSetDescription(InvToGLBuffer, InvToGLRecon);
            InvToGLBuffer."Cost Amount (Expected)":=InvToGLRecon.Sum_Cost_Amount_Expected;
            InvToGLBuffer."Cost Amount (Expected) (ACY)":=InvToGLRecon.Sum_Cost_Amount_Expected_ACY;
            InvToGLBuffer."Expected Cost Posted to G/L":=InvToGLRecon.Sum_Expected_Cost_Posted_to_GL;
            InvToGLBuffer."Exp. Cost Posted to G/L (ACY)":=InvToGLRecon.Sum_Exp_Cost_Posted_to_GL_ACY;
            InvToGLBuffer."Valued Quantity":=InvToGLRecon.Sum_Valued_Quantity;
            InvToGLBuffer."Invoiced Quantity":=InvToGLRecon.Sum_Invoiced_Quantity;
            InvToGLBuffer."Cost Amount (Actual)":=InvToGLRecon.Sum_Cost_Amount_Actual;
            InvToGLBuffer."Cost Amount (Actual) (ACY)":=InvToGLRecon.Sum_Cost_Amount_Actual_ACY;
            InvToGLBuffer."Cost Posted to G/L":=InvToGLRecon.Sum_Cost_Posted_to_G_L;
            InvToGLBuffer."Cost Posted to G/L (ACY)":=InvToGLRecon.Sum_Cost_Posted_to_G_L_ACY;
            InvToGLBuffer.CreateValues(Rec, true, false);
            InvToGLBuffer.Modify;
        end;
        InvToGLRecon.SetRange(No, Item."No.");
        InvToGLRecon.SetRange(Date_Filter, 0D, "To Date");
        InvToGLRecon.SetFilter(Valued_Quantity, '>0');
        InvToGLRecon.Open;
        while InvToGLRecon.Read do begin
            CreateRowSetDescription(InvToGLBuffer, InvToGLRecon);
            InvToGLBuffer."Cost Amount (Expected)":=InvToGLRecon.Sum_Cost_Amount_Expected;
            InvToGLBuffer."Cost Amount (Expected) (ACY)":=InvToGLRecon.Sum_Cost_Amount_Expected_ACY;
            InvToGLBuffer."Expected Cost Posted to G/L":=InvToGLRecon.Sum_Expected_Cost_Posted_to_GL;
            InvToGLBuffer."Exp. Cost Posted to G/L (ACY)":=InvToGLRecon.Sum_Exp_Cost_Posted_to_GL_ACY;
            InvToGLBuffer."Valued Quantity":=InvToGLRecon.Sum_Valued_Quantity;
            InvToGLBuffer."Invoiced Quantity":=InvToGLRecon.Sum_Invoiced_Quantity;
            InvToGLBuffer."Cost Amount (Actual)"+=InvToGLRecon.Sum_Cost_Amount_Actual;
            InvToGLBuffer."Cost Amount (Actual) (ACY)"+=InvToGLRecon.Sum_Cost_Amount_Actual_ACY;
            InvToGLBuffer."Cost Posted to G/L"+=InvToGLRecon.Sum_Cost_Posted_to_G_L;
            InvToGLBuffer."Cost Posted to G/L (ACY)"+=InvToGLRecon.Sum_Cost_Posted_to_G_L_ACY;
            InvToGLBuffer.CreateValues(Rec, false, true);
            InvToGLBuffer.Modify;
        end;
    end;
    local procedure CreateRowSetDescription(var InvToGLBuffer: Record "ForNAV Inventory to G/L Buffer";
    var InvToGLRecon: Query "ForNAV Inventory to G/L Recon.")begin
        if not InvToGLBuffer.Get(InvToGLRecon.No, InvToGLRecon.Variant_Code, InvToGLRecon.Location_Code)then begin
            InvToGLBuffer.Init;
            InvToGLBuffer."Item No.":=InvToGLRecon.No;
            InvToGLBuffer."Variant Code":=InvToGLRecon.Variant_Code;
            InvToGLBuffer."Location Code":=InvToGLRecon.Location_Code;
            InvToGLBuffer.Insert;
        end;
    end;
}
