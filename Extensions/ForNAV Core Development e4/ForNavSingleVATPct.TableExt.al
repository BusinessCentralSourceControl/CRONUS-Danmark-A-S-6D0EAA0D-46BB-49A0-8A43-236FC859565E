tableextension 6188684 ForNavSingleVATPct extends "VAT Amount Line"
{
    fields
    {
    }
    procedure ForNavSingleVATPct(): Decimal var VatPct: Decimal;
    begin
        VatPct:=-1;
        if Rec.FindFirst()then repeat if VatPct = -1 then VatPct:=Rec."VAT %"
                else if Rec."VAT %" <> VatPct then exit(0);
            until Rec.Next() <> 1;
        if VatPct <= 0 then exit(0);
        exit(VatPct);
    end;
}
