###
@namespace scoping into the CQL_QDM namespace
###
@CQL_QDM ||= {}


###
Represents a patient (using the HDS model) for use by the CQL execution
engine.
###
class CQL_QDM.CQLPatient
  constructor: (@patient, @measure) ->
    @_patient = @patient
    @_datatypes = @buildDatatypes()

  ###
  @returns {String}
  ###
  id: ->
    @_patient.id

  ###
  @returns {Object}
  ###
  findRecords: (profile) ->
    if profile == 'Patient' # Requested generic patient info
      @getPatientInfo()
    else if /PatientCharacteristicSex/.test profile # Requested gender
      [@_patient.get('gender')]
    else if profile?
      # Requested something else. Need to properly handle Positive / Negative
      # (negated) data criteria for QDM 5.0+.
      profile = profile.replace(/ *\{[^)]*\} */g, "") # Strip model details
      if /Positive/.test profile
        profile = profile.replace /Positive/, ""
        return @filterDataCriteria profile, false
      else if /Negative/.test profile
        profile = profile.replace /Negative/, ""
        return @filterDataCriteria profile, true
      else
        if @_datatypes[profile]? then return @_datatypes[profile] else []
    else
      []

  ###
  @returns {Array}
  ###
  filterDataCriteria: (profile, isNegated) ->
    # Search patient's history for data criteria that match the given
    # profile (keeping in mind negated status).
    results = []
    if @_datatypes[profile]?
      for dataCriteria in @_datatypes[profile]
        if dataCriteria._negationRationale? == isNegated
          results.push dataCriteria
    results

  ###
  @returns {Object}
  ###
  buildDatatypes: ->
    types = [
      'allergies',
      'care_goals',
      'conditions',
      'encounters',
      'communications',
      'family_history',
      'immunizations',
      'medical_equipment',
      'medications',
      'procedures',
      'results',
      'social_history',
      'vital_signs'
    ]
    datatypes = {}
    for type in types
      data_criteria = @_patient.get(type)
      if data_criteria
        for dc in data_criteria
          if dc.oid == null
            classname = dc.description.substr(0, dc.description.indexOf(':'))
          else
            classname = CQL_QDM.OIDMap.oidToClassName(dc)
          unless datatypes[classname]?
            datatypes[classname] = []
          cql_dc = new CQL_QDM[classname](dc)
          cql_dc['bonnie_type'] = type
          datatypes[classname].push cql_dc
    datatypes

  ###
  @returns {Object}
  ###
  getPatientInfo: ->
    info = {}
    info['birthDatetime'] = cql.DateTime.fromDate(moment(@_patient.get('birthdate'), 'X').toDate())
    [info]
