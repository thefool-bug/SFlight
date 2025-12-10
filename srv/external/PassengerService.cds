/* checksum : 857c4766e45ab7dc67622cfafa5c26bc */
@cds.external : true
@cds.persistence.skip : true
@Common.SideEffects#alwaysFetchMessages.$Type : 'Common.SideEffectsType'
@Common.SideEffects#alwaysFetchMessages.SourceEntities : [ ![($self)] ]
@Common.DraftRoot.$Type : 'Common.DraftRootType'
@Common.DraftRoot.ActivationAction : 'PassengerService.draftActivate'
@Common.DraftRoot.EditAction : 'PassengerService.draftEdit'
@Common.DraftRoot.PreparationAction : 'PassengerService.draftPrepare'
entity PassengerService.Passenger {
  @odata.Precision : 7
  @odata.Type : 'Edm.DateTimeOffset'
  @UI.HiddenFilter : true
  @UI.ExcludeFromNavigationContext : true
  @Core.Immutable : true
  @Core.Computed : true
  @Common.Label : '{i18n>CreatedAt}'
  createdAt : Timestamp;
  /** {i18n>UserID.Description} */
  @UI.HiddenFilter : true
  @UI.ExcludeFromNavigationContext : true
  @Core.Immutable : true
  @Core.Computed : true
  @Common.Label : '{i18n>CreatedBy}'
  createdBy : String(255);
  @odata.Precision : 7
  @odata.Type : 'Edm.DateTimeOffset'
  @UI.HiddenFilter : true
  @UI.ExcludeFromNavigationContext : true
  @Core.Computed : true
  @Common.Label : '{i18n>ChangedAt}'
  modifiedAt : Timestamp;
  /** {i18n>UserID.Description} */
  @UI.HiddenFilter : true
  @UI.ExcludeFromNavigationContext : true
  @Core.Computed : true
  @Common.Label : '{i18n>ChangedBy}'
  modifiedBy : String(255);
  key CustomerID : String(6) not null;
  FirstName : String(40);
  LastName : String(40);
  Title : String(10);
  Street : String(60);
  PostalCode : String(10);
  City : String(40);
  /** {i18n>CountryCode.Description} */
  @Common.Label : '{i18n>Country}'
  CountryCode : Association to one PassengerService.Countries {  };
  /** {i18n>CountryCode.Description} */
  @Common.Label : '{i18n>Country}'
  @Common.ValueList.$Type : 'Common.ValueListType'
  @Common.ValueList.Label : '{i18n>Country}'
  @Common.ValueList.CollectionPath : 'Countries'
  @Common.ValueList.Parameters : [
    {
      $Type: 'Common.ValueListParameterInOut',
      LocalDataProperty: CountryCode_code,
      ValueListProperty: 'code'
    },
    {
      $Type: 'Common.ValueListParameterDisplayOnly',
      ValueListProperty: 'name'
    }
  ]
  CountryCode_code : String(3);
  PhoneNumber : String(30);
  EMailAddress : String(256);
  @UI.Hidden : true
  key IsActiveEntity : Boolean not null default true;
  @UI.Hidden : true
  HasActiveEntity : Boolean not null default false;
  @UI.Hidden : true
  HasDraftEntity : Boolean not null default false;
  @UI.Hidden : true
  DraftAdministrativeData : Association to one PassengerService.DraftAdministrativeData {  };
  SiblingEntity : Association to one PassengerService.Passenger {  };
} actions {
  action draftPrepare(
    ![in] : $self,
    SideEffectsQualifier : String
  ) returns PassengerService.Passenger;
  action draftActivate(
    ![in] : $self
  ) returns PassengerService.Passenger;
  action draftEdit(
    ![in] : $self,
    PreserveChanges : Boolean
  ) returns PassengerService.Passenger;
};

@cds.external : true
@cds.persistence.skip : true
@UI.Identification : [
  {
    $Type: 'UI.DataField',
    Value: name
  }
]
entity PassengerService.Countries {
  @Common.Label : '{i18n>Name}'
  name : String(255);
  @Common.Label : '{i18n>Description}'
  descr : String(1000);
  @Common.Text : name
  @Common.Label : '{i18n>CountryCode}'
  key code : String(3) not null;
  texts : Composition of many PassengerService.Countries_texts {  };
  localized : Association to one PassengerService.Countries_texts {  };
};

@cds.external : true
@cds.persistence.skip : true
@Common.Label : '{i18n>Draft_DraftAdministrativeData}'
entity PassengerService.DraftAdministrativeData {
  @UI.Hidden : true
  @Common.Label : '{i18n>Draft_DraftUUID}'
  @Core.ComputedDefaultValue : true
  key DraftUUID : UUID not null;
  @odata.Precision : 7
  @odata.Type : 'Edm.DateTimeOffset'
  @Common.Label : '{i18n>Draft_CreationDateTime}'
  CreationDateTime : Timestamp;
  @Common.Label : '{i18n>Draft_CreatedByUser}'
  CreatedByUser : String(256);
  @UI.Hidden : true
  @Common.Label : '{i18n>Draft_DraftIsCreatedByMe}'
  DraftIsCreatedByMe : Boolean;
  @odata.Precision : 7
  @odata.Type : 'Edm.DateTimeOffset'
  @Common.Label : '{i18n>Draft_LastChangeDateTime}'
  LastChangeDateTime : Timestamp;
  @Common.Label : '{i18n>Draft_LastChangedByUser}'
  LastChangedByUser : String(256);
  @Common.Label : '{i18n>Draft_InProcessByUser}'
  InProcessByUser : String(256);
  @UI.Hidden : true
  @Common.Label : '{i18n>Draft_DraftIsProcessedByMe}'
  DraftIsProcessedByMe : Boolean;
};

@cds.external : true
@cds.persistence.skip : true
entity PassengerService.Countries_texts {
  @Common.Label : '{i18n>LanguageCode}'
  key locale : String(14) not null;
  @Common.Label : '{i18n>Name}'
  name : String(255);
  @Common.Label : '{i18n>Description}'
  descr : String(1000);
  @Common.Text : name
  @Common.Label : '{i18n>CountryCode}'
  key code : String(3) not null;
};

@cds.external : true
type PassengerService.DRAFT_DraftAdministrativeData_DraftMessage {
  code : String;
  message : String;
  target : String;
  additionalTargets : many String;
  transition : Boolean;
  @odata.Type : 'Edm.Byte'
  numericSeverity : Integer;
  longtextUrl : String;
};

@cds.external : true
@Common.AddressViaNavigationPath : true
service PassengerService {};

