Authorization took much more time then i thought
# Done:
 - user can use app without authorization - for browsing popular and current broadcasting movies
 - if user tries to get favorite movies list or add to favorite user promted to authorize

 - network layer:
    - separate protocols for different purposes
    
 - authorization:
    - authorization primarily done in 'AuthWorker'
    - user permission request in WebView 'UserAuthPermissionWebViewController'
    - any request can be wrapped via generic decorator 'AuthenticationNetworkDecorator'

 - account id fetch:
    -- any request can be wrapped via generic decorator 'AccountDetailsProviderNetworkDecorator'
    
 - movies list (popular, current broadcast, my favorites)
    - fetch image for cell (small resolution) and display in cell
    - movies list pagination
    - cancel image fetch in 'prepareForReuse'
 
# TODO (approx 5 hours):
 - movies list 
    - alerts with errors 
    - refresh indicator during load
 
 - movie detail screen:
    - cancel request if user leave from screen
    
- implement way of syncronizing favorites (now we can only add to favorites and when loading movie details screen we do not know what is favorite)


#  Cellcom home task requirments

IOS Developer.  Technical exam

Dear candidate, here is a test that largely simulates some of the requirements that you will have to fulfill in a development position in our company.
The time for the exam – 3.5 hours

The Task: 
You need to build an app that shows movies.
Instructions:
    1. Visit https://www.themoviedb.org/
    2. The site offers api at https://www.themoviedb.org/documentation/api
    3. Use api key = 2c46288716a18fb7aadcc2a801f3fc6b to save the registration.
    4. A new application must be created that knows how to perform the following actions:
        ● Show all popular movies on the home page.
        ● Option to filter results by popular, currently broadcast, my favorites.
        ● By clicking on one of the movies the movie details screen will be open and there should be possible to mark a movie as a favorite.
Highlights:
    1. Must be developed in SWIFT
    2. The following issues should be noted:
        a. components display correct in different screen sizes
        b. separation of concerns
        c. coding principles
        d. naming conventions
        e. readability
        f. error handling for timeouts, missing or incorrect fields
    3. External libraries can be used
    4. Pay attention to the efficiency of loading information from the API and the speed of loading the application
    
At the end of the development
Create a repository in github and push to the necessary files for proper compilation.
Make sure that in the clone from the repository, you can compile the application and run it on a simulator


