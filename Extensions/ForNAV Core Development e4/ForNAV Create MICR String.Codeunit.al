Codeunit 6188778 "ForNAV Create MICR String"
{
    trigger OnRun()begin
    end;
    procedure GetMICRString(var ForNAVCheckModel: Record "ForNAV Check Model")var CheckSetup: Record "ForNAV Check Setup";
    begin
        CheckSetup.Get;
        if CheckSetup."MICR Encoding" in[CheckSetup."micr encoding"::None, CheckSetup."micr encoding"::"Defined with Per-Tenant Extension"]then exit;
        if CheckSetup."MICR Encoding" = CheckSetup."micr encoding"::"Amount + Check No. + Routing No. + Bank Account No." then begin
            ForNAVCheckModel."Micr Line 1":=AmountSymbol;
            ForNAVCheckModel."Micr Line 1"+=GetCentsFromAmount(ForNAVCheckModel."Amount Paid");
            ForNAVCheckModel."Micr Line 1"+=GetAmountPrefixedWithZeroes(ForNAVCheckModel."Amount Paid");
            ForNAVCheckModel."Micr Line 1"+=AmountSymbol;
        end;
        ForNAVCheckModel."Micr Line 2":=NonUSSymbol;
        ForNAVCheckModel."Micr Line 2"+=AddZeroesToCheckNo(ForNAVCheckModel."Check No.");
        ForNAVCheckModel."Micr Line 2"+=NonUSSymbol;
        ForNAVCheckModel."Micr Line 3":=TransitSymbol;
        ForNAVCheckModel."Micr Line 3"+=ForNAVCheckModel."Bank Routing No.";
        ForNAVCheckModel."Micr Line 3"+=TransitSymbol;
        ForNAVCheckModel."Micr Line 3"+=ForNAVCheckModel."Bank Account No.";
        ForNAVCheckModel."Micr Line 3"+=TransitSymbol;
        ForNAVCheckModel."Micr Line":=ForNAVCheckModel."Micr Line 1" + ForNAVCheckModel."Micr Line 2" + ForNAVCheckModel."Micr Line 3";
    end;
    local procedure TransitSymbol(): Code[1]begin
        exit('A');
    end;
    local procedure AmountSymbol(): Code[1]begin
        exit('B');
    end;
    local procedure NonUSSymbol(): Code[1]begin
        exit('C');
    end;
    local procedure DashSymbol(): Code[1]begin
        exit('D');
    end;
    local procedure GetCentsFromAmount(Value: Decimal)Cents: Code[2]begin
        // Only Cents
        Value:=Value - ROUND(Value, 1, '<');
        Cents:=CopyStr(Format(Value * 100), 1, 2);
        while StrLen(Cents) < 2 do Cents:='0' + Cents;
    end;
    local procedure GetAmountPrefixedWithZeroes(Value: Decimal)Amount: Code[13]begin
        Value:=ROUND(Value, 1, '<');
        Amount:=DelChr(Format(Value), '<>', '.,');
        while StrLen(Amount) < 13 do Amount:='0' + Amount;
    end;
    local procedure AddZeroesToCheckNo(Value: Text): Text begin
        if StrLen(Value) >= 6 then exit(Value);
        while StrLen(Value) < 6 do Value:='0' + Value;
        exit(Value);
    end;
}
