using { sap.fe.cap.travel as my } from '../db/schema';
using { PassengerService as external } from './external/PassengerService';

service TravelService @(path:'/processor') {

  @(restrict: [
    { grant: 'READ', to: 'authenticated-user'},
    { grant: ['rejectTravel','acceptTravel','pendTravel','deductDiscount'], to: 'reviewer'},
    { grant: ['*'], to: 'processor'},
    { grant: ['*'], to: 'admin'}
  ])
  entity Travel as projection on my.Travel {
    *,
    to_Passenger: Association to Passenger on to_Passenger.CustomerID = to_Customer
  } actions {
    action createTravelByTemplate() returns Travel;
    action rejectTravel();
    action acceptTravel();
    action pendTravel( reason : String );
    action deductDiscount( percent: Percentage not null ) returns Travel;
  };
  entity Passenger as projection on external.Passenger;
  action PendingInBatch(
    travelIDs: array of String,
    reason: String
  );

}

type Percentage : Integer @assert.range: [1,100];
