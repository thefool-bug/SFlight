sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageBox",
    "sap/m/MessageToast"
], function (Controller, MessageBox, MessageToast) {
    "use strict";

    return Controller.extend("your.namespace.ListReport", { // 替换 your.namespace 为你的实际命名空间

        /**
         * 自定义按钮处理函数：批量设为 Pending
         */
        onPendingInBatchPress: function () {
            const that = this;
            const oView = this.getView();
            const oTable = oView.byId("myTable"); // 如果你没有显式 ID，可使用 oView.byId("__table0")

            if (!oTable) {
                MessageBox.error("Table not found.");
                return;
            }

            const aSelectedContexts = oTable.getSelectedContexts();
            if (aSelectedContexts.length === 0) {
                MessageBox.warning("Please select at least one travel item.");
                return;
            }

            const aTravelIDs = aSelectedContexts.map(oContext => {
                return oContext.getProperty("TravelID");
            });

            // 弹出输入框获取 reason
            MessageBox.input({
                title: "Set to Pending",
                value: "",
                placeholder: "Enter reason...",
                onClose: function (sReason) {
                    if (!sReason || sReason.trim() === "") {
                        MessageBox.warning("Reason is required.");
                        return;
                    }

                    // 调用 unbound action
                    that.editFlow.invokeAction("PendingInBatch", {
                        travelIDs: aTravelIDs,
                        reason: sReason.trim()
                    }).then(function () {
                        // ✅ 关键：刷新整个模型以更新列表状态
                        oView.getModel().refresh();
                        MessageToast.show("Selected travels have been set to Pending status.");
                    }).catch(function (oError) {
                        let sMessage = oError.message || "An unknown error occurred.";
                        MessageBox.error("Failed to update status:\n" + sMessage);
                    });
                }
            });
        }
    });
});