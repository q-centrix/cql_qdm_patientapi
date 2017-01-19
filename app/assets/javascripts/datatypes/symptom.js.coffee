###
@namespace scoping into the CQL_QDM namespace
###
@CQL_QDM ||= {}


###
Data elements that meet criteria using this datatype should document the
symptom and its corresponding value set. The onset datetime corresponds to the
implicit start datetime of the datatype and the abatement datetime corresponds
to the implicit stop datetime of the datatype. If the abatement datetime is
null, then the symptom is considered to still be active. When this datatype is
used with timing relationships, the criterion is looking for whether the
symptom was active for the time frame indicated by the timing relationships.
###
class CQL_QDM.Symptom extends CQL_QDM.QDMDatatype
  constructor: (@entry) ->
    super @entry
    @_abatementDatetime = CQL_QDM.Helpers.convertDateTime(@entry.abatementDatetime)
    @_onsetDatetime = CQL_QDM.Helpers.convertDateTime(@entry.start_time)
    @_severity = @entry.severity

  ###
  @returns {Date}
  ###
  abatementDatetime: ->
    cql.DateTime.fromDate(@_abatementDatetime)

  ###
  @returns {Date}
  ###
  onsetDatetime: ->
    cql.DateTime.fromDate(@_onsetDatetime)

  ###
  @returns {Code}
  ###
  severity: ->
    new cql.Code(@_severity?.code, @_severity?.code_system)