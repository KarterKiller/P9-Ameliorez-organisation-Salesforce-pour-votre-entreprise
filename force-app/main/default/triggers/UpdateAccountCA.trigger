trigger UpdateAccountCA on Order (after insert, after update, after delete) {
    UpdateAccountCAHelper.updateAccountChiffreDAffaire(Trigger.new, Trigger.old, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete);
}
