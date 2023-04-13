public with sharing class CocktailService {
    @InvocableMethod
    public static List<List<Drink>> getCocktails(List<DrinkRequest> requestDetail) {
        List<List<Drink>> drinksListWrapper = new List<List<Drink>>();
        List<Drink> drinksList = new List<Drink>();
        HttpRequest request = buildRequest(requestDetail[0].urlParameters);
        HTTPResponse response = makeCallout(request);
        if(response != null && response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
            drinksListWrapper.add(processResponse(response));
        }
        return drinksListWrapper;
    }
    private static List<Drink> processResponse(HTTPResponse response) {
        List<Drink> drinksList = new List<Drink>();
        try{
            Map<String,Object> responseMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            String drinkString = (String) JSON.serialize(responseMap.get('drinks'));
            Drink[] drinks = (Drink[])JSON.deserialize(drinkString,Drink[].class);
            
            for(Drink drink : drinks){
                drinksList.add(drink);
            }
        }catch(Exception e) {
            //TODO add better error handling
            system.debug(logginglevel.ERROR, e.getMessage());
            return null;
        }
        return drinksList; 
    }
    private static HttpRequest buildRequest(String urlParameters){
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:the_cocktail_db'+urlParameters);
        request.setHeader('X-RapidAPI-Key', '{!$Credential.Password}');
        request.setHeader('X-RapidAPI-Host', 'the-cocktail-db.p.rapidapi.com');
        return request;
    }
    private static HTTPResponse makeCallout(HttpRequest request) {
        try{
            Http http = new Http();
            HTTPResponse response = http.send(request);
            return response;
        }catch(Exception e) {
            //TODO add better error handling
            system.debug(logginglevel.ERROR, e.getMessage());
            return null;
        }
    }
    
    public class DrinkRequest {
        @InvocableVariable
        public String urlParameters;
    }
}