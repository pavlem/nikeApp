# Nike App Test Project

## Instructions
- Download and run the app, no 3rd party libs. 
- Install on a real device, simulator will have issues, it will work only for the first time, but later it will not. The reason is that the web site is failing to establish a connection or complete a handshake, especially after the first run. It's specific to the Simulator and often occurs with servers using Cloudflare or HTTP/3 (like fakestoreapi.com does).

## Features
- Portrait and Landscape mode supported 
- Dark light mode supported
- Checkout will work every second time. If it fails, an alert error will be shown
- There are two main screens (tabs), PRODUCTS and CART. Products will download data from the fakestore while Cart will show products added to cart ordered by date (last will be the firs in the list) 
- On product tap, product details is opened where we can add it or remove it from the cart.
- In cart tab, on cart item tap, product will again be opened and we can also add or remove it from the cart list. 
- In cart list there is also swipe to delete feature
- In cart list we can also see number of items and total price
- Tapping on the checkout button we have one final alert confirmation and then a loading screen where we call again a fake api "https://httpbin.org/delay/3” which will return an answer after 3 second. This site is FLAKY and in case of an error try again 

- Portrait and Landscape mode supported 
- Dark light mode supported
- Checkout will work every second time. If it fails, an alert error will be shown


## Architecture:
- MVVM and CLEAN architecture used
- Folder structure is separated into UI and ENGINE (view and business domain).
- In UI we have Views, ViewModels separated into logical units while in ENGINE we have UseCases, Comms, APIs, Utils, Factories, Data

#### **Components**

The application uses a common design pattern throughout. This is based on Clean Architecture Principles. Each “layer” of the architecture is separated by Protocols following the Interface Segregation Principle (ISP) and Dependency Inversion principle (DIP). This allows dependencies to be injected during object creation and test mocks to be created during unit testing to allow the independent testing of components.

Each View in the application has the structure outlined below (black arrows indicate ownership, white arrows indicate inheritance), see the image:

![alt_text](arch.png "image_tooltip")


#### **ViewModel**

Calls UseCase methods to do work and updates Views. Events are communicated asynchronously with the View using Swift concurency. A ViewModel can utilise the functionality provided by a number of UseCases to achieve its goals.


#### **UseCase**

Encapsulates the Business Logic of the application. UseCases typically use APIs and Managers to get resources, convert the resources into core Data objects and return those to the caller. UseCases utilise Async Await (Swift Concurrency) to handle data communication and asynchronous processes. A UseCase can combine the functionality provided by a number of other UseCases and/or Manager and API classes to achieve its goals. Consolidates errors to a set of UseCase specific errors.\

#### **API**

Generates a Comms Request Object and uses the CommsSession to send this request and parse the response. Parses JSON responses to DTO objects or generates networking errors. APIs utilise Swift Concurrency to handle asynchronous operations and error propagation.


#### **Data / DTO objects**

APIs handle DTO objects which are defined by the web APIs. These typically use non-standard naming conventions such as underscores to separate words (`address_line_1`). DTOs are mapped to application specific Data objects for use by the application beyond the UseCase boundary.

## Error Handling strategy

Data is passed from API -> UseCase -> ViewModel via do try catch. Errors are consolidated at each level and passed along the chain. At the ViewModel level these errors are converted to alerts and the View handles the rendering of that.

For example, an API error (E.g. ClientAPIError) is converted by the UseCase into a specific UseCaseError (ClientUseCaseError.invalidClientIdError). This reduces the error set to a known set for this particular UseCase. The UseCase passes this UseCaseError to the ViewModel which then handles and displays to the user depending on the Error and the UX of the screen.

## Test Strategy

* Unit testing
    * Unit tests have been written as a show case what can be done

* Target code coverage would be:
    * Use cases
    * View models
    * Data models

* Target code coverage exclusions:
    * UI, Manager and Utility components where OS level code and API calls are integrated such as:
        * Factories
        * Comms
* UI testing - XCUITest can be used with Snapshot testing framework. In this case I did not implement them 
