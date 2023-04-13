public with sharing class CocktailServiceTest {
    //TODO finish up tests
    @isTest
    public static void makeCallout_ExpectSuccess(){
        //TODO: define requestDetail to pass
        Case caseRecord = [SELECT Id FROM Case LIMIT 1];
        HeApiRequest requestDetail = new HeApiRequest();
        
        HTTPRequest request = new HTTPRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:the_cocktail_db');
        request.setHeader('X-RapidAPI-Key', '{!$Credential.Password}');
        request.setHeader('X-RapidAPI-Host', 'the-cocktail-db.p.rapidapi.com');

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CocktailDatabaseMockCallout());
            Http http = new Http();
            HTTPResponse response = http.send(request);
        Test.stopTest();
        System.assertEquals(200,response.getStatusCode());
    }
}