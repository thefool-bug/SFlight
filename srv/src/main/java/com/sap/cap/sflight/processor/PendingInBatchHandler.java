package com.sap.cap.sflight.processor;

import static cds.gen.travelservice.TravelService_.TRAVEL;

import java.util.Collection;
import java.util.HashMap;

import org.springframework.stereotype.Component;

import com.sap.cds.ql.Update;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;

import cds.gen.travelservice.PendingInBatchContext;
import cds.gen.travelservice.Travel;
import cds.gen.travelservice.TravelService_;

@Component
@ServiceName(TravelService_.CDS_NAME)
public class PendingInBatchHandler implements EventHandler {

	private static final String TRAVEL_STATUS_OPEN = "O";
	private static final String TRAVEL_STATUS_PENDING = "P";

    private final PersistenceService persistenceService;

    public PendingInBatchHandler(PersistenceService persistenceService) {
        this.persistenceService = persistenceService;
    }

    @On(event = PendingInBatchContext.CDS_NAME)
    public void onPendingInBatch(PendingInBatchContext context) {
        Collection<?> ids = context.travelIDs();
        if (ids == null || ids.isEmpty()) {
            context.setCompleted();
            return;
        }

        // Run as privileged user to allow updates across draft/active entities
        context.getCdsRuntime().requestContext().privilegedUser().run(ctx -> {
            // Convert incoming ids to Integer list since TravelID is INTEGER
            java.util.List<Integer> intIds = new java.util.ArrayList<>();
            for (Object o : ids) {
                if (o == null) continue;
                if (o instanceof Number) {
                    intIds.add(((Number) o).intValue());
                } else {
                    try {
                        intIds.add(Integer.valueOf(o.toString()));
                    } catch (NumberFormatException ex) {
                        // ignore invalid id values
                    }
                }
            }
            if (!intIds.isEmpty()) {
                // Update Travel status code to 'P' only for Travels currently in status 'O'
                Integer[] idsArray = intIds.toArray(new Integer[0]);
                HashMap<String, Object> data = new HashMap<>();
                data.put(Travel.TRAVEL_STATUS_CODE, TRAVEL_STATUS_PENDING);
                data.put(Travel.REASON_TEXT, context.reason());
                persistenceService.run(Update.entity(TRAVEL)
                    .where(t -> t.TravelID().in(idsArray).and(t.TravelStatus_code().eq(TRAVEL_STATUS_OPEN)))
                    .data(data));
            }
        });
        // Return completed (note: to return a payload from Java runtime,
        // regenerate Java sources after updating CDS so the context API supports a result())
        context.setCompleted();
    }
}
