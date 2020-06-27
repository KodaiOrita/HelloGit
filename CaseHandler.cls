public class CaseHandler {
    public void beforeCreateCase(List<Case> cases) {
        Set<String> spNumbers = new Set<String>();
        Set<String> SuppliedNames = new Set<String>();
        Set<String> SuppliedEmails = new Set<String>();
        Set<String> SuppliedPhones = new Set<String>();
        Set<String> homeAddresses = new Set<String>();
        
        for(Case cas : cases){
            //originがwebのみの場合のみ3点チェックする。メールから直接は標準のメールtoケースを利用
            if(cas.origin !=null && cas.origin.equals('Web')){
                if(cas.spNumber__c != null){
                    spNumbers.add(cas.spNumber__c);
                }
                if(case.SuppliedName != null){
                    SuppliedNames.add(cas.SuppliedName);
                }
                if(case.SuppliedEmail != null){
                    SuppliedEmails.add(cas.SuppliedEmail);
                }
                if(case.SuppliedPhone != null){
                    SuppliedPhones.add(cas.SuppliedPhone);
                }
                //住所もあとで実装する。くっつけたりしないといけない。
            }
        }
        List<Contact> contactList = new List<Contact>([SELECT Id, spNumber__c, Name,Email,HomePhone FROM Contact WHERE spNumber__c=:spNumbers OR Name=:SuppliedNames OR Email=:SuppliedEmails OR HomePhone=:SuppliedPhones]);
                
        for(Case cas : cases){
            //originがwebのみの場合のみ3点チェックする。
            if(cas.origin !=null && cas.origin.equals('Web')){
                boolean isContactMatched = false;
                for(Contact conts : contactList){
                    Integer numMatch = 0; 
                    if(cas.spNumber__c != null && cas.spNumber__c.equals(conts.spNumber__c)){
                        numMatch ++;
                    }
                    if(cas.SuppliedName != null && cas.SuppliedName.equals(conts.Name)){
                        numMatch ++;
                    }
                    if(cas.SuppliedEmail != null && cas.SuppliedEmail.equals(conts.Email)){
                        numMatch ++;
                    }
                    //本当は自宅電話番号と携帯電話番号クロスでチェックする.Phone,HomePhone,MobilePhoneすべてチェックする。
                    if((cas.SuppliedPhone !=null && cas.SuppliedPhone.equals(conts.Phone))
                            || (cas.SuppliedPhone !=null && cas.SuppliedPhone.equals(conts.HomePhone))
                            || (cas.SuppliedPhone !=null && cas.SuppliedPhone.equals(conts.MobilePhone)))
                            {
                        numMatch ++;
                    }
                    
                    if(numMatch >= 3){
                        cas.ContactId = conts.Id;
                        isContactMatched = True;
                        break;
                    }
                }
                if(isContactMatched == false){
                    cas.ContactId = null;
                }
            }
        }
    }
}