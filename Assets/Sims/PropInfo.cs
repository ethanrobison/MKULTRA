﻿using System;
using System.Collections.Generic;
using System.Linq;
using Prolog;

using UnityEngine;

public class PropInfo : PhysicalObject
{
    /// <summary>
    /// True if this is a container that can hold other things.
    /// </summary>
    public bool IsContainer;

    /// <summary>
    /// The word for this type of object
    /// </summary>
    public string CommonNoun;
    /// <summary>
    /// The plural form of the word for this type of object
    /// </summary>
    public string Plural;

    /// <summary>
    /// Any adjectives to attach to this object
    /// </summary>
    public string[] Adjectives=new string[0];

    public override void Awake()
    {
        base.Awake();
        foreach (var o in Contents)
            o.Container = gameObject;

        if (string.IsNullOrEmpty(CommonNoun))
            CommonNoun = name.ToLower();
        CommonNoun = StringUtils.LastWordOf(CommonNoun);
        if (string.IsNullOrEmpty(Plural) && !string.IsNullOrEmpty(CommonNoun))
            Plural = StringUtils.PluralForm(CommonNoun);
    }

    public void Start()
    {
        if (!KB.Global.IsTrue("register_prop",
                                gameObject, Symbol.Intern(CommonNoun),
                                Symbol.Intern(Plural),
                                // Mono can't infer the type on this, for some reason
                                // ReSharper disable once RedundantTypeArgumentsOfMethod
                                Prolog.Prolog.IListToPrologList(new List<Symbol>(Adjectives.Select<string,Symbol>(Symbol.Intern))))
            )
            throw new Exception("Can't register prop "+name);
    }

    #region Container operations
    public IEnumerable<PhysicalObject> Contents
    {
        get
        {
            foreach (Transform child in transform)
                yield return child.GetComponent<PhysicalObject>();
        }
    } 
    #endregion
}
