public class AccountTriggerHandler {
    public static void handleBeforeInsert(List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            if (acc.Name == null || acc.Name.trim() == '') {
                acc.addError('Account Name is required');
            }
        }
    }

    public static void handleAfterInsert(List<Account> newAccounts) {
        List<Task> tasksToCreate = new List<Task>();
        for (Account acc : newAccounts) {
            Task t = new Task(
                Subject = 'Follow up with new account',
                WhatId = acc.Id,
                Status = 'Open',
                Priority = 'High'
            );
            tasksToCreate.add(t);
        }
        if (!tasksToCreate.isEmpty()) {
            insert tasksToCreate;
        }
    }
}

public class OpportunityService {
    public static List<Opportunity> getOpenOpportunities() {
        return [SELECT Id, Name, Amount, StageName, CloseDate
                FROM Opportunity
                WHERE IsClosed = false
                ORDER BY CloseDate ASC];
    }

    public static void closeDeals(List<Opportunity> opps) {
        for (Opportunity opp : opps) {
            if (opp.Amount != null && opp.Amount > 0) {
                opp.StageName = 'Closed Won';
            }
        }
        update opps;
    }
}

public class ContactHelper {
    public static void deduplicate() {
        List<AggregateResult> duplicates = [
            SELECT Email, COUNT(Id) cnt
            FROM Contact
            GROUP BY Email
            HAVING COUNT(Id) > 1
        ];

        Set<String> duplicateEmails = new Set<String>();
        for (AggregateResult ar : duplicates) {
            duplicateEmails.add((String)ar.get('Email'));
        }

        List<Contact> contactsToDelete = new List<Contact>();
        Map<String, Contact> emailToContact = new Map<String, Contact>();

        for (Contact c : [SELECT Id, Email, CreatedDate
                          FROM Contact
                          WHERE Email IN :duplicateEmails
                          ORDER BY Email, CreatedDate]) {
            if (emailToContact.containsKey(c.Email)) {
                contactsToDelete.add(c);
            } else {
                emailToContact.put(c.Email, c);
            }
        }

        if (!contactsToDelete.isEmpty()) {
            delete contactsToDelete;
        }
    }
}
