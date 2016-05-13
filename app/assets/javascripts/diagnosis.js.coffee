###
Based on the QDM 4.2 Documentation - Section 4.1.4
###

@cql_qdm_patientapi ||= {}


###
Data elements that meet criteria using this datatype should document the
Condition/Diagnosis/Problem and its corresponding value set. The onset
datetime corresponds to the implicit start datetime of the datatype and the
abatement datetime corresponds to the implicit stop datetime of the datatype.
If the abatement datetime is null, then the diagnosis is considered to still
be active. When this datatype is used with timing relationships, the criterion
is looking for an active diagnosis for the time frame indicated by the timing
relationships.
###
class cql_qdm_patientapi.Diagnosis
  constructor: (@entry) ->
    @_abatementDatetime = @entry.abatementDatetime
    @_onsetDatetime = @entry.onsetDatetime
    @_anatomicalLocationSite = @entry.anatomical_location
    @_severity = @entry.severity

  ###
  @returns {Date}
  ####
  abatementDatetime: -> cql.DateTime.fromDate(moment.utc(@_abatementDatetime, 'X').toDate())

  ###
  @returns {Date}
  ####
  onsetDatetime: -> cql.DateTime.fromDate(moment.utc(@_onsetDatetime, 'X').toDate())

  ###
  @returns {Code}
  ####
  anatomicalLocationSite: -> cql.Code(@_anatomicalLocationSite.code, @_anatomicalLocationSite.code_system)

  ###
  @returns {Code}
  ####
  severity: -> cql.Code(@_severity.code, @_severity.code_system)
