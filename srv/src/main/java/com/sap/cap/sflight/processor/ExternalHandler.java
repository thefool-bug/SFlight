package com.sap.cap.sflight.processor;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.sap.cds.Result;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.messaging.TopicMessageEventContext;

import cds.gen.travelservice.TravelService_;
import cds.gen.travelservice.Passenger_;
import cds.gen.passengerservice.PassengerService_;

@Component
@ServiceName(TravelService_.CDS_NAME)
public class ExternalHandler implements EventHandler {

    Logger logger = LoggerFactory.getLogger(ExternalHandler.class);

    @Autowired
    @Qualifier(PassengerService_.CDS_NAME)
    CqnService ps;

    @On(entity = Passenger_.CDS_NAME)
    Result readPassenger(CdsReadEventContext context){
        return ps.run(context.getCqn());
    }

    @On(service = "PassengerMessage",event = "sap.cap.passenger.v1.PassengerService.changed.v1")
    private void afterPassengerChanged(TopicMessageEventContext context) {
        Map<String,Object> event = context.getDataMap();
        logger.info("Receiving: '" + event.toString() + "'");
    }

}
