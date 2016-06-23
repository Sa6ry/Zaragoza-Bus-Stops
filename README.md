# Zaragoza Bus Stops Info iOS App

Zaragoza App, is a simple app that shows the bus stops in the Zaragoza city, including the following information
- The number of the bus stop
- The name of the bus stop
- A small map image of the area around the bus stop ­ Time until the next bus arrives the bus stop.

## Data Classes

- BusStop: Hold information regarding the bus stop (id, station name, location ..etc)
- BusStopComingBus: Hold information regarding the incoming bust to the station (estimate, bus number, direction ..etc)

## UI Classes

- BusStationCollectionViewCell: Base class the collection view cell used to display the station info
- ModernStationInfoCollectionViewCell: collection view cell used to dispaly the station info in the "modern" view controller
- ClassicStationInfoCollectionViewCell: collection view cell used to dispaly the station info in the "classic" view controller
- ClassicBusListCollectionViewController: View controller used to display the station info in a classic format
- ModernBusListViewController: View controler used to disaply the station info in a modern format

## Network Classes
- WebBaseAPI: The base class that is being used by the API to GET data
- BusStopListAPI: get a list for all the bus stations in the city
- BusStopComingBusesAPI: for fetching information regarding the incoming bus to the station
- GoogleMapImageAPI: for fetching images from google map server

## Installation

The Code is known to work best with iOS 9.0 on iPhone devices, it plays niceley on iPad and haven't been tested on earlier iOS versions
I tried two different approaches, the first one I named 'classic' & the second one I named 'modern'

## TODO
- Unit Test & UI Test
- The search & refresh button in the classic view controller are not functioning
- A loading animation while featching the bus station list
- Adding caching to fast loading the bus station list
- Adding features like "Favorite" to make the app more usable
- Adding icon, loading screen to make things more fancy
- Saving the user state, like the last search filter for better usability

## BUGS
- Handling & showing network errors (currently we assume things go smothly)
- Handling the case when the user press "No" when being asked to allow location service
- Google map images sometime return bad images (cause we are using the free version!)
- The coming bus information sometime fail and return "(null)". this case is not handled
- Canceling the already running network request if the cell is not being displayed any more!



