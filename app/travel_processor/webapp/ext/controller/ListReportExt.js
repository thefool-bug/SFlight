sap.ui.define([
  "sap/m/MessageBox",
], function (MessageBox) {
  "use strict";

  return {
    PendingInBatch: async function() {
      this.editFlow.invokeAction("PendingInBatch", {
        model: this.getModel(),
          parameterValues: [
            { name: "TravelID", value: "" },
            { name: "reason", value: "" }
          ],
          skipSideEffects: true
        })
        .then(() => {
          this.routing.getView().getModel().refresh();
        })
        .catch(function () {
          MessageBox.show("{Error Occur}", { icon: MessageBox.Icon.ERROR });
        });
    }
  };
});